/* Copyright 2016 Esteve Fernandez <esteve@apache.org>
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
import org.ros2.rcljava.interfaces.MessageDefinition;
import org.ros2.rcljava.interfaces.ServiceDefinition;
import org.ros2.rcljava.node.Node;
import org.ros2.rcljava.node.NodeImpl;
import org.ros2.rcljava.publisher.Publisher;
import org.ros2.rcljava.qos.QoSProfile;
import org.ros2.rcljava.service.RMWRequestId;
import org.ros2.rcljava.service.Service;
import org.ros2.rcljava.subscription.Subscription;

/**
 * Entry point for the ROS2 Java API, similar to the rclcpp API.
 */
public final class RCLJava {

  private static final Logger logger = LoggerFactory.getLogger(RCLJava.class);

  /**
   * Private constructor so this cannot be instantiated.
   */
  private RCLJava() { }

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

    RMW_TO_TYPESUPPORT = new ConcurrentSkipListMap<String, String>() {{
        put("rmw_fastrtps_c", "rosidl_typesupport_introspection_c");
        put("rmw_fastrtps_cpp", "rosidl_typesupport_introspection_c");
        put("rmw_opensplice_cpp", "rosidl_typesupport_opensplice_c");
        put("rmw_connext_cpp", "rosidl_typesupport_connext_c");
        put("rmw_connext_dynamic_cpp", "rosidl_typesupport_introspection_c");
      }
    };

    Runtime.getRuntime().addShutdownHook(new Thread() {
      public void run() {
        cleanup();
      }
    });
  }

  /**
   * The identifier of the currently active RMW implementation.
   */
  private static String rmwImplementation = null;

  /**
   * Flag to indicate if RCLJava has been fully initialized, with a valid RMW
   *   implementation.
   */
  private static boolean initialized = false;

  /**
   * A mapping between RMW implementations and their typesupports.
   */
  private static final Map<String, String> RMW_TO_TYPESUPPORT;

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
  public static void rclJavaInit() {
    synchronized (RCLJava.class) {
      if (!initialized) {
        if (RCLJava.rmwImplementation == null) {
          for (Map.Entry<String, String> entry
               : RMW_TO_TYPESUPPORT.entrySet()) {

            try {
              setRMWImplementation(entry.getKey());
              break;
            } catch (UnsatisfiedLinkError ule) {
              // TODO(esteve): handle exception
            } catch (Exception exc) {
              // TODO(esteve): handle exception
            }
          }
        }
        if (RCLJava.rmwImplementation == null) {
          logger.error("No RMW implementation found");
          System.exit(1);
        } else {
          nativeRCLJavaInit();
          logger.info("Using RMW implementation: {}", getRMWIdentifier());
          initialized = true;
        }
      }
    }
  }

  /**
   * Initialize the underlying rcl layer.
   */
  private static native void nativeRCLJavaInit();

  /**
   * Create a ROS2 node (rcl_node_t) and return a pointer to it as an integer.
   *
   * @param nodeName The name that will identify this node in a ROS2 graph.
   * @return A pointer to the underlying ROS2 node structure.
   */
  private static native long nativeCreateNodeHandle(String nodeName);

  public static String getTypesupportIdentifier() {
    return RMW_TO_TYPESUPPORT.get(nativeGetRMWIdentifier());
  }

  public static void setRMWImplementation(
      final String rmwImplementation) throws Exception {

    synchronized (RCLJava.class) {
      JNIUtils.loadLibrary(RCLJava.class, rmwImplementation);
      RCLJava.rmwImplementation = rmwImplementation;
    }
  }

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
  private static native boolean nativeOk();

  /**
   * @return true if RCLJava hasn't been shut down, false otherwise.
   */
  public static boolean ok() {
    return nativeOk();
  }

  /**
   * Create a @{link Node}.
   *
   * @param nodeName The name that will identify this node in a ROS2 graph.
   * @return A @{link Node} that represents the underlying ROS2 node
   *     structure.
   */
  public static Node createNode(final String nodeName) {
    long nodeHandle = nativeCreateNodeHandle(nodeName);
    Node node = new NodeImpl(nodeHandle);
    nodes.add(node);
    return node;
  }

  public static void spinOnce(final Node node) {
    long waitSetHandle = nativeGetZeroInitializedWaitSet();

    nativeWaitSetInit(waitSetHandle, node.getSubscriptions().size(), 0, 0,
        node.getClients().size(), node.getServices().size());

    nativeWaitSetClearSubscriptions(waitSetHandle);

    nativeWaitSetClearServices(waitSetHandle);

    nativeWaitSetClearClients(waitSetHandle);

    for (Subscription<MessageDefinition> subscription : node.getSubscriptions()) {
      nativeWaitSetAddSubscription(
          waitSetHandle, subscription.getHandle());
    }

    for (Service<ServiceDefinition> service : node.getServices()) {
      nativeWaitSetAddService(waitSetHandle, service.getHandle());
    }

    for (Client<ServiceDefinition> client : node.getClients()) {
      nativeWaitSetAddClient(waitSetHandle, client.getHandle());
    }

    nativeWait(waitSetHandle);

    for (Subscription<MessageDefinition> subscription : node.getSubscriptions()) {
      MessageDefinition message = nativeTake(
          subscription.getHandle(),
          subscription.getMessageType());
      if (message != null) {
        subscription.getCallback().accept(message);
      }
    }

    for (Service service : node.getServices()) {
      Class<MessageDefinition> requestType = service.getRequestType();
      Class<MessageDefinition> responseType = service.getResponseType();

      MessageDefinition requestMessage = null;
      MessageDefinition responseMessage = null;

      try {
        requestMessage = requestType.newInstance();
        responseMessage = responseType.newInstance();
      } catch (InstantiationException ie) {
        ie.printStackTrace();
        continue;
      } catch (IllegalAccessException iae) {
        iae.printStackTrace();
        continue;
      }

      long requestFromJavaConverterHandle =
          requestMessage.getFromJavaConverterInstance();
      long requestToJavaConverterHandle =
          requestMessage.getToJavaConverterInstance();
      long responseFromJavaConverterHandle =
          responseMessage.getFromJavaConverterInstance();
      long responseToJavaConverterHandle =
          responseMessage.getToJavaConverterInstance();

      RMWRequestId rmwRequestId =
          nativeTakeRequest(service.getHandle(),
          requestFromJavaConverterHandle, requestToJavaConverterHandle,
          requestMessage);
      if (rmwRequestId != null) {
        service.getCallback().accept(rmwRequestId, requestMessage, responseMessage);
        nativeSendServiceResponse(service.getHandle(), rmwRequestId,
            responseFromJavaConverterHandle, responseToJavaConverterHandle,
            responseMessage);
      }
    }

    for (Client<ServiceDefinition> client : node.getClients()) {
      Class<MessageDefinition> requestType = client.getRequestType();
      Class<MessageDefinition> responseType = client.getResponseType();

      MessageDefinition requestMessage = null;
      MessageDefinition responseMessage = null;

      try {
        requestMessage = requestType.newInstance();
        responseMessage = responseType.newInstance();
      } catch (InstantiationException ie) {
        ie.printStackTrace();
        continue;
      } catch (IllegalAccessException iae) {
        iae.printStackTrace();
        continue;
      }

      long requestFromJavaConverterHandle =
          requestMessage.getFromJavaConverterInstance();
      long requestToJavaConverterHandle =
          requestMessage.getToJavaConverterInstance();
      long responseFromJavaConverterHandle =
          responseMessage.getFromJavaConverterInstance();
      long responseToJavaConverterHandle =
          responseMessage.getToJavaConverterInstance();

      RMWRequestId rmwRequestId = nativeTakeResponse(
          client.getHandle(), responseFromJavaConverterHandle,
          responseToJavaConverterHandle, responseMessage);

      if (rmwRequestId != null) {
        client.handleResponse(rmwRequestId, responseMessage);
      }
    }
  }

  private static native void nativeShutdown();

  public static void shutdown() {
    cleanup();
    nativeShutdown();
  }

  private static native long nativeGetZeroInitializedWaitSet();

  private static native void nativeWaitSetInit(
      long waitSetHandle, int numberOfSubscriptions,
      int numberOfGuardConditions, int numberOfTimers,
      int numberOfClients, int numberOfServices);

  private static native void nativeWaitSetClearSubscriptions(
      long waitSetHandle);

  private static native void nativeWaitSetAddSubscription(
      long waitSetHandle, long subscriptionHandle);

  private static native void nativeWait(long waitSetHandle);

  private static native MessageDefinition nativeTake(long subscriptionHandle,
      Class<MessageDefinition> messageType);

  private static native void nativeWaitSetClearServices(long waitSetHandle);

  private static native void nativeWaitSetAddService(long waitSetHandle,
      long serviceHandle);

  private static native void nativeWaitSetClearClients(long waitSetHandle);

  private static native void nativeWaitSetAddClient(long waitSetHandle,
      long clientHandle);

  private static native RMWRequestId nativeTakeRequest(
      long serviceHandle, long requestFromJavaConverterHandle,
      long requestToJavaConverterHandle, MessageDefinition requestMessage);

  private static native void nativeSendServiceResponse(long serviceHandle,
      RMWRequestId header, long responseFromJavaConverterHandle,
      long responseToJavaConverterHandle, MessageDefinition responseMessage);

  private static native RMWRequestId nativeTakeResponse(
      long clientHandle, long responseFromJavaConverterHandle,
      long responseToJavaConverterHandle, MessageDefinition responseMessage);

  public static long convertQoSProfileToHandle(final QoSProfile qosProfile) {
    int history = qosProfile.getHistory().getValue();
    int depth = qosProfile.getDepth();
    int reliability = qosProfile.getReliability().getValue();
    int durability = qosProfile.getDurability().getValue();

    return nativeConvertQoSProfileToHandle(history, depth, reliability,
      durability);
  }

  private static native long nativeConvertQoSProfileToHandle(
      int history, int depth, int reliability, int durability);

  public static void disposeQoSProfile(final long qosProfileHandle) {
    nativeDisposeQoSProfile(qosProfileHandle);
  }

  private static native void nativeDisposeQoSProfile(
      long qosProfileHandle);
}
