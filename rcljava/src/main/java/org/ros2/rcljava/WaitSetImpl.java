/* Copyright 2018 Esteve Fernandez <esteve@apache.org>
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

import org.ros2.rcljava.client.Client;
import org.ros2.rcljava.subscription.Subscription;

public class WaitSetImpl implements WaitSet {
  private static final Logger logger = LoggerFactory.getLogger(WaitSetImpl.class);

  static {
    try {
      JNIUtils.loadImplementation(WaitSetImpl.class);
    } catch (UnsatisfiedLinkError ule) {
      logger.error("Native code library failed to load.\n" + ule);
      System.exit(1);
    }
  }

  private long handle;

  public WaitSet() {
    handle = nativeGetZeroInitializedWaitSet();
  }

  private boolean clientIsReady(long index) {
    return nativeWaitSetClientIsReady(handle, index);
  }

  private boolean serviceIsReady(long index) {
    return nativeWaitSetServiceIsReady(handle, index);
  }

  private boolean subscriptionIsReady(long index) {
    return nativeWaitSetSubscriptionIsReady(handle, index);
  }

  private boolean timerIsReady(long index) {
    return nativeWaitSetTimerIsReady(handle, index);
  }

  private long getZeroInitializedWaitSet() {
    return nativeGetZeroInitializedWaitSet();
  }

  private void addClient(Client client) {
    nativeWaitSetAddClient(handle, client.getHandle());
  }

  private void addService(Service service) {
    nativeWaitSetAddService(handle, service.getHandle());
  }

  private void addSubscription(Subscription subscription) {
    nativeWaitSetAddSubscription(handle, subscription.getHandle());
  }

  private void addTimer(Timer timer) {
    nativeWaitSetAddTimer(handle, timer.getHandle());
  }

  private void clearClients() {
    nativeWaitSetClearClients(handle);
  }

  private void clearServices() {
    nativeWaitSetClearServices(handle);
  }

  private void clearSubscriptions() {
    nativeWaitSetClearSubscriptions(handle);
  }

  private void clearTimers() {
    nativeWaitSetClearTimers(handle);
  }

  private void init(int numberOfSubscriptions, int numberOfGuardConditions, int numberOfTimers,
      int numberOfClients, int numberOfServices) {
    nativeWaitSetInit(handle, numberOfSubscriptions, numberOfGuardConditions, numberOfTimers,
        numberOfClients, numberOfServices);
  }

  private static native boolean nativeWaitSetClientIsReady(long waitSetHandle, long index);

  private static native boolean nativeWaitSetServiceIsReady(long waitSetHandle, long index);

  private static native boolean nativeWaitSetSubscriptionIsReady(long waitSetHandle, long index);

  private static native boolean nativeWaitSetTimerIsReady(long waitSetHandle, long index);

  private static native long nativeGetZeroInitializedWaitSet();

  private static native void nativeWaitSetAddClient(long waitSetHandle, long clientHandle);

  private static native void nativeWaitSetAddService(long waitSetHandle, long serviceHandle);

  private static native void nativeWaitSetAddSubscription(
      long waitSetHandle, long subscriptionHandle);

  private static native void nativeWaitSetAddTimer(long waitSetHandle, long timerHandle);

  private static native void nativeWaitSetClearClients(long waitSetHandle);

  private static native void nativeWaitSetClearServices(long waitSetHandle);

  private static native void nativeWaitSetClearSubscriptions(long waitSetHandle);

  private static native void nativeWaitSetClearTimers(long waitSetHandle);

  private static native void nativeWaitSetInit(long waitSetHandle, int numberOfSubscriptions,
      int numberOfGuardConditions, int numberOfTimers, int numberOfClients, int numberOfServices);
}
