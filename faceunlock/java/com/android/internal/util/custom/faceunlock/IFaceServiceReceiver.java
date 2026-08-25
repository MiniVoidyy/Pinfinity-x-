package com.android.internal.util.custom.faceunlock;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.RemoteException;

public interface IFaceServiceReceiver extends IInterface {
    void onEnrollResult(int faceId, int userId, int remaining) throws RemoteException;
    void onAuthenticated(int faceId, int userId, byte[] token) throws RemoteException;
    void onAcquired(int userId, int acquiredInfo, int vendorCode) throws RemoteException;
    void onError(int error, int vendorCode) throws RemoteException;
    void onRemoved(int[] removed, int userId) throws RemoteException;
    void onEnumerate(int[] faceIds, int userId) throws RemoteException;
    void onLockoutChanged(long duration) throws RemoteException;

    abstract static class Stub extends Binder implements IFaceServiceReceiver {
        private static final String DESCRIPTOR = "com.android.internal.util.custom.faceunlock.IFaceServiceReceiver";

        public Stub() {
            attachInterface(this, DESCRIPTOR);
        }

        public static IFaceServiceReceiver asInterface(IBinder obj) {
            if (obj == null) {
                return null;
            }
            IInterface iface = obj.queryLocalInterface(DESCRIPTOR);
            if (iface instanceof IFaceServiceReceiver) {
                return (IFaceServiceReceiver) iface;
            }
            return null;
        }

        @Override
        public IBinder asBinder() {
            return this;
        }
    }
}
