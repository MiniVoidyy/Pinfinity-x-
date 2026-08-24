/* Pinfinity X - shell/settings helpers used by the embedded page. */
package com.android.settings.pinfinity;

import android.content.Context;
import android.provider.Settings;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public final class SysOps {

    private SysOps() {}

    /** Run a shell command, returning combined stdout/stderr (trimmed). */
    public static String sh(String cmd) {
        try {
            Process p = new ProcessBuilder("sh", "-c", cmd)
                    .redirectErrorStream(true).start();
            BufferedReader r = new BufferedReader(
                    new InputStreamReader(p.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = r.readLine()) != null) sb.append(line).append('\n');
            p.waitFor();
            return sb.toString().trim();
        } catch (Exception e) {
            return "";
        }
    }

    /** setprop with automatic root fallback (custom kernels ship su). */
    public static void setProp(String name, String value) {
        sh("setprop " + name + " " + value);
        if (!value.equals(sh("getprop " + name))) {
            sh("su -c 'setprop " + name + " " + value + "'");
        }
    }

    public static boolean hasSu() {
        return !sh("su -c id").isEmpty();
    }

    public static void putGlobal(Context c, String key, String value) {
        try { Settings.Global.putString(c.getContentResolver(), key, value); }
        catch (Exception e) { toast(c, "Failed: " + key); }
    }

    public static void putGlobalInt(Context c, String key, int v) {
        try { Settings.Global.putInt(c.getContentResolver(), key, v); }
        catch (Exception e) { toast(c, "Failed: " + key); }
    }

    public static void putSystem(Context c, String key, String value) {
        try { Settings.System.putString(c.getContentResolver(), key, value); }
        catch (Exception e) { toast(c, "Failed: " + key); }
    }

    public static void putSystemInt(Context c, String key, int v) {
        try { Settings.System.putInt(c.getContentResolver(), key, v); }
        catch (Exception e) { toast(c, "Failed: " + key); }
    }

    public static void putSystemFloat(Context c, String key, float v) {
        try { Settings.System.putFloat(c.getContentResolver(), key, v); }
        catch (Exception e) { toast(c, "Failed: " + key); }
    }

    /** device_config put <ns> <key> <value> */
    public static void deviceConfig(String ns, String key, String value) {
        sh("device_config put " + ns + " " + key + " " + value);
    }

    public static void overlaySetEnabled(String pkg, boolean enable) {
        sh("cmd overlay " + (enable ? "enable" : "disable") +
                " --user 0 " + pkg);
    }

    public static void restartSystemUI() {
        String out = sh("pkill -TERM -f com.android.systemui");
        if (out.contains("denied") || out.isEmpty()) {
            sh("su -c 'pkill -TERM -f com.android.systemui'");
        }
    }

    public static void trimCaches() {
        sh("pm trim-caches 999G");
        sh("su -c 'pm trim-caches 999G'");
    }

    private static void toast(Context c, String msg) {
        Toast.makeText(c, msg, Toast.LENGTH_SHORT).show();
    }
}
