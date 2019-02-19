/* Copyright 2016-2018 Esteve Fernandez <esteve@apache.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.ros2.rcljava;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentSkipListMap;
import java.util.concurrent.LinkedBlockingQueue;

import org.ros2.rcljava.client.Client;
import org.ros2.rcljava.common.JNIUtils;
import org.ros2.rcljava.executors.SingleThreadedExecutor;
import org.ros2.rcljava.interfaces.MessageDefinition;
import org.ros2.rcljava.interfaces.ServiceDefinition;
import org.ros2.rcljava.node.ComposableNode;
import org.ros2.rcljava.node.Node;
import org.ros2.rcljava.node.NodeImpl;
import org.ros2.rcljava.publisher.Publisher;
import org.ros2.rcljava.qos.QoSProfile;
import org.ros2.rcljava.service.RMWRequestId;
import org.ros2.rcljava.service.Service;
import org.ros2.rcljava.subscription.Subscription;
import org.ros2.rcljava.timer.Timer;

/**
 * Entry point for the ROS2 Java API, similar to the rclcpp API.
 */
public final class RCLJava {
  private static final Logger logger = LoggerFactory.getLogger(RCLJava.class);

  private static SingleThreadedExecutor globalExecutor = null;

  private static SingleThreadedExecutor getGlobalExecutor() {
    synchronized (RCLJava.class) {
      if (globalExecutor == null) {
        globalExecutor = new SingleThreadedExecutor();
      }
      return globalExecutor;
    }
  }

  /**
   * Private constructor so this cannot be instantiated.
   */
  private RCLJava() {}

  /**
   * All the @{link Node}s that have been created.
   */
  private static Collection<Node> nodes;

  private static void cleanup() {
    for (Node node : nodes) {
      for (Subscription subscription : node.getSubscriptions()) {
        subscription.dispose();
      }

      for (Publisher publisher : node.getPublishers()) {
        publisher.dispose();
      }

      for (Timer timer : node.getTimers()) {
        timer.dispose();
      }

      for (Service service : node.getServices()) {
        service.dispose();
      }

      for (Client client : node.getClients()) {
        client.dispose();
      }

      node.dispose();
    }
  }

  static {
    nodes = new LinkedBlockingQueue<Node>();

    // NOTE(esteve): disabling shutdown hook for now to avoid JVM crashes
    // Runtime.getRuntime().addShutdownHook(new Thread() {
    //   public void run() {
    //     cleanup();
    //   }
    // });
  }

  /**
   * Flag to indicate if RCLJava has been fully initialized, with a valid RMW
   *   implementation.
   */
  private static boolean initialized = false;

  /**
   * @return true if RCLJava has been fully initialized, false otherwise.
   */
  public static boolean isInitialized() {
    return RCLJava.initialized;
  }

  /**
   * Initialize the RCLJava API. If successful, a valid RMW implementation will
   *   be loaded and accessible, enabling the creating of ROS2 entities
   *   (@{link Node}s, @{link Publisher}s and @{link Subscription}s.
   */
  public static long rclJavaInit(String... args) {
    synchronized (RCLJava.class) {
      if (!RCLJava.initialized) {
        try {
          JNIUtils.loadImplementation(RCLJava.class);
        } catch (UnsatisfiedLinkError ule) {
          logger.error("Native code library failed to load.\n" + ule);
          System.exit(1);
        }
        long contextHandle = nativeCreateContext();
        RCLJava.nativeRCLJavaInit(contextHandle, args);
        logger.info("Using RMW implementation: {}", RCLJava.getRMWIdentifier());
        initialized = true;
        return contextHandle;
      }
    }
    return 0;
  }

  /**
   * Create context.
   */
  private static native long nativeCreateContext();
  
  /**
   * Initialize the underlying rcl layer.
   */
  private static native void nativeRCLJavaInit(long context, String... args);

  /**
   * Create a ROS2 node (rcl_node_t) and return a pointer to it as an integer.
   *
   * @param nodeName The name that will identify this node in a ROS2 graph.
   * @param namespace The namespace of the node.
   * @return A pointer to the underlying ROS2 node structure.
   */
  private static native long nativeCreateNodeHandle(String nodeName, String namespace, long contextHandle);

  /**
   * @return The identifier of the currently active RMW implementation via the
   *     native ROS2 API.
   */
  private static native String nativeGetRMWIdentifier();

  /**
   * @return The identifier of the currently active RMW implementation.
   */
  public static String getRMWIdentifier() {
    return nativeGetRMWIdentifier();
  }

  /**
   * Call the underlying ROS2 rcl mechanism to check if ROS2 has been shut
   *   down.
   *
   * @return true if RCLJava hasn't been shut down, false otherwise.
   */
  private static native boolean nativeOk(long contextHandle);

  /**
   * @return true if RCLJava hasn't been shut down, false otherwise.
   */
  public static boolean ok(long contextHandle) {
    return nativeOk(contextHandle);
  }

  /**
   * Create a @{link Node}.
   *
   * @param nodeName The name that will identify this node in a ROS2 graph.
   * @return A @{link Node} that represents the underlying ROS2 node
   *     structure.
   */
  public static Node createNode(final String nodeName, long contextHandle) {
    return createNode(nodeName, "", contextHandle);
  }

  /**
   * Create a @{link Node}.
   *
   * @param nodeName The name that will identify this node in a ROS2 graph.
   * @param namespace The namespace of the node.
   * @return A @{link Node} that represents the underlying ROS2 node
   *     structure.
   */
  public static Node createNode(final String nodeName, final String namespace, long contextHandle) {
    long nodeHandle = nativeCreateNodeHandle(nodeName, namespace, contextHandle);
    Node node = new NodeImpl(nodeHandle, nodeName, contextHandle);
    nodes.add(node);
    return node;
  }

  public static void spin(final Node node, long contextHandle) {
    ComposableNode composableNode = new ComposableNode() {
      public Node getNode() {
        return node;
      }
    };
    getGlobalExecutor().addNode(composableNode);
    getGlobalExecutor().spin(contextHandle);
    getGlobalExecutor().removeNode(composableNode);
  }

  public static void spin(final ComposableNode composableNode, long contextHandle) {
    getGlobalExecutor().addNode(composableNode);
    getGlobalExecutor().spin(contextHandle);
    getGlobalExecutor().removeNode(composableNode);
  }

  public static void spinOnce(final Node node) {
    ComposableNode composableNode = new ComposableNode() {
      public Node getNode() {
        return node;
      }
    };
    getGlobalExecutor().addNode(composableNode);
    getGlobalExecutor().spinOnce();
    getGlobalExecutor().removeNode(composableNode);
  }

  public static void spinOnce(final ComposableNode composableNode) {
    getGlobalExecutor().addNode(composableNode);
    getGlobalExecutor().spinOnce();
    getGlobalExecutor().removeNode(composableNode);
  }

  public static void spinSome(final Node node) {
    ComposableNode composableNode = new ComposableNode() {
      public Node getNode() {
        return node;
      }
    };
    getGlobalExecutor().addNode(composableNode);
    getGlobalExecutor().spinSome();
    getGlobalExecutor().removeNode(composableNode);
  }

  public static void spinSome(final ComposableNode composableNode) {
    getGlobalExecutor().addNode(composableNode);
    getGlobalExecutor().spinSome();
    getGlobalExecutor().removeNode(composableNode);
  }

  private static native void nativeShutdown(long contextHandle);

  private static native void nativeDeleteContext(long contextHandle);
  
  public static void shutdown(long contextHandle) {
    cleanup();
    nativeShutdown(contextHandle);
    nativeDeleteContext(contextHandle);
  }

  public static long convertQoSProfileToHandle(final QoSProfile qosProfile) {
    int history = qosProfile.getHistory().getValue();
    int depth = qosProfile.getDepth();
    int reliability = qosProfile.getReliability().getValue();
    int durability = qosProfile.getDurability().getValue();
    boolean avoidROSNamespaceConventions = qosProfile.getAvoidROSNamespaceConventions();

    return nativeConvertQoSProfileToHandle(
        history, depth, reliability, durability, avoidROSNamespaceConventions);
  }

  private static native long nativeConvertQoSProfileToHandle(int history, int depth,
      int reliability, int durability, boolean avoidROSNamespaceConventions);

  public static void disposeQoSProfile(final long qosProfileHandle) {
    nativeDisposeQoSProfile(qosProfileHandle);
  }

  private static native void nativeDisposeQoSProfile(long qosProfileHandle);
}
