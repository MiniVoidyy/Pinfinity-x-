package com.android.internal.util.custom.faceunlock;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.RemoteException;

public interface IFaceService extends IInterface {
    void setCallback(IFaceServiceReceiver receiver) throws RemoteException;
    long generateChallenge(int timeoutSec) throws RemoteException;
    void revokeChallenge() throws RemoteException;
    void enroll(byte[] hardwareAuthToken, int timeoutSec, int[] disabledFeatures) throws RemoteException;
    void authenticate(long operationId) throws RemoteException;
    void cancel() throws RemoteException;
    void enumerate() throws RemoteException;
    void remove(int faceId) throws RemoteException;
    boolean getFeature(int feature, int faceId) throws RemoteException;
    void setFeature(int feature, boolean enabled, byte[] hardwareAuthToken, int faceId) throws RemoteException;
    void resetLockout(byte[] hardwareAuthToken) throws RemoteException;
    long getAuthenticatorId() throws RemoteException;

    abstract static class Stub extends Binder implements IFaceService {
        private static final String DESCRIPTOR = "com.android.internal.util.custom.faceunlock.IFaceService";

        public Stub() {
            attachInterface(this, DESCRIPTOR);
        }

        public static IFaceService asInterface(IBinder obj) {
            if (obj == null) {
                return null;
            }
            IInterface iface = obj.queryLocalInterface(DESCRIPTOR);
            if (iface instanceof IFaceService) {
                return (IFaceService) iface;
            }
            return null;
        }

        @Override
        public IBinder asBinder() {
            return this;
        }
    }
}
