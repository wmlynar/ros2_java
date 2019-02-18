/* Copyright 2017-2018 Esteve Fernandez <esteve@apache.org>
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

package org.ros2.rcljava.executors;

import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;

import org.ros2.rcljava.RCLJava;
import org.ros2.rcljava.node.ComposableNode;
import org.ros2.rcljava.executors.BaseExecutor;

public class MultiThreadedExecutor implements Executor {
  private BaseExecutor baseExecutor;
  private ExecutorService threadpool;
  private Object mutex;
  private int numberOfThreads;

  public MultiThreadedExecutor(int numberOfThreads) {
    this.baseExecutor = new BaseExecutor();
    this.threadpool = Executors.newFixedThreadPool(numberOfThreads);
    this.mutex = new Object();
    this.numberOfThreads = numberOfThreads;
  }

  public MultiThreadedExecutor() {
    this(Runtime.getRuntime().availableProcessors());
  }

  public void addNode(ComposableNode node) {
    this.baseExecutor.addNode(node);
  }

  public void removeNode(ComposableNode node) {
    this.baseExecutor.removeNode(node);
  }

  public void spinOnce() {
    spinOnce(-1);
  }

  public void spinOnce(long timeout) {
    this.baseExecutor.spinOnce(timeout);
  }

  public void spinSome() {
    this.baseExecutor.spinSome();
  }

  public void spin(final long contextHandle) {
    synchronized (mutex) {
      for (int i = 0; i < this.numberOfThreads; i++) {
        this.threadpool.execute(new Runnable() {
          public void run() {
            MultiThreadedExecutor.this.run(contextHandle);
          }
        });
      }
    }
    this.threadpool.shutdown();
  }

  private void run(long contextHandle) {
    while (RCLJava.ok(contextHandle)) {
      synchronized (mutex) {
        this.spinOnce();
      }
    }
  }
}
