package com.android.internal.util.custom.faceunlock;

import android.content.ComponentName;
import android.content.Intent;

public class FaceUnlockUtils {
    private static final String FACE_UNLOCK_SERVICE_PACKAGE = "org.pixelexperience.faceunlock";
    private static final String FACE_UNLOCK_SERVICE_CLASS =
            "org.pixelexperience.faceunlock.services.FaceService";

    /**
     * Stub build: the faceunlock service app does not exist, so report the
     * feature as unsupported. All call sites guard on this and skip the
     * custom face paths entirely.
     */
    public static boolean isFaceUnlockSupported() {
        return false;
    }

    public static Intent getServiceIntent() {
        return new Intent().setComponent(
                new ComponentName(FACE_UNLOCK_SERVICE_PACKAGE, FACE_UNLOCK_SERVICE_CLASS));
    }

    public static String getServicePackageName() {
        return FACE_UNLOCK_SERVICE_PACKAGE;
    }
}
