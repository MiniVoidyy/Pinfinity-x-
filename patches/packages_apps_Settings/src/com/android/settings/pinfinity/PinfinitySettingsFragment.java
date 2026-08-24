/*
 * Pinfinity X - settings page embedded in AOSP Settings.
 * Appears at the top of the main Settings list ("Pinfinity settings").
 */
package com.android.settings.pinfinity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.PowerManager;
import android.provider.Settings;
import android.widget.Toast;

import androidx.preference.ListPreference;
import androidx.preference.Preference;
import androidx.preference.PreferenceFragmentCompat;
import androidx.preference.SwitchPreferenceCompat;

import java.util.ArrayList;
import java.util.List;

public class PinfinitySettingsFragment extends PreferenceFragmentCompat {

    private static final String TAG = "PinfinitySettings";
    private static final String ULTRA_OVERLAY = "com.pinfinity.x.ultra.overlay";

    @Override
    protected String getLogTag() {
        return TAG;
    }

    @Override
    public int getMetricsCategory() {
        // Not part of MetricsEvent enums; Settings logs this as VIEW_UNKNOWN.
        return 0;
    }

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        setPreferencesFromResource(R.xml.pinfinity_settings, rootKey);
        bind();
    }

    private void bind() {
        Context ctx = getContext();

        // ---------------- Performance ----------------
        anim("anim_window",  Settings.System.WINDOW_ANIMATION_SCALE);
        anim("anim_transition", Settings.System.TRANSITION_ANIMATION_SCALE);
        anim("anim_animator", Settings.System.ANIMATOR_DURATION_SCALE);

        ListPreference scroll = findPref("scroll_profile");
        scroll.setOnPreferenceChangeListener((p, v) -> {
            boolean ultra = "ultra".equals(v);
            SysOps.overlaySetEnabled(ULTRA_OVERLAY, ultra);
            toast(ultra ? R.string.scroll_ultra_on : R.string.scroll_balanced);
            return true;
        });

        SwitchPreferenceCompat freezer = findPref("freezer");
        freezer.setOnPreferenceChangeListener((p, v) -> {
            SysOps.deviceConfig("activity_manager_settings",
                    "cached_apps_freezer_enabled", Boolean.toString(v));
            return true;
        });

        ListPreference ram = findPref("ram_profile");
        ram.setOnPreferenceChangeListener((p, v) -> {
            String val = "aggressive".equals(v) ? "20"
                       : "relaxed".equals(v)    ? "48" : "32";
            SysOps.deviceConfig("activity_manager", "max_cached_processes", val);
            return true;
        });

        ListPreference bgl = findPref("bg_limit");
        bgl.setOnPreferenceChangeListener((p, v) -> {
            SysOps.putGlobalInt(ctx,
                    Settings.Global.BACKGROUND_PROCESS_LIMIT,
                    Integer.parseInt(v));
            return true;
        });

        ListPreference renderer = findPref("renderer");
        renderer.setOnPreferenceChangeListener((p, v) -> {
            if ("auto".equals(v)) {
                SysOps.setProp("debug.hwui.renderer", "");
            } else {
                SysOps.setProp("debug.hwui.renderer", v);
            }
            toast(R.string.restart_systemui_hint);
            return true;
        });

        prefClick("fstrim", () -> {
            String out = SysOps.sh("su -c 'fstrim -v /data'");
            toast(out.isEmpty() ? R.string.fstrim_no_root : R.string.fstrim_done);
        });

        // ---------------- UI / System ----------------
        ListPreference font = findPref("font_scale");
        font.setOnPreferenceChangeListener((p, v) -> {
            SysOps.putSystem(ctx, Settings.System.FONT_SCALE, v);
            return true;
        });

        ListPreference timeout = findPref("screen_timeout");
        timeout.setOnPreferenceChangeListener((p, v) -> {
            SysOps.putSystemInt(ctx, Settings.System.SCREEN_OFF_TIMEOUT,
                    Integer.parseInt(v));
            return true;
        });

        SwitchPreferenceCompat dark = findPref("dark_force");
        dark.setOnPreferenceChangeListener((p, v) -> {
            SysOps.sh("cmd uimode night " + (((Boolean) v) ? "yes" : "auto"));
            return true;
        });

        toggle("show_taps", Settings.System.SHOW_TOUCHES);
        toggle("pointer_loc", Settings.System.POINTER_LOCATION);

        // ---------------- Gaming ----------------
        prefClick("game_apps", this::pickGameApp);

        ListPreference thermal = findPref("thermal_profile");
        thermal.setOnPreferenceChangeListener((p, v) -> {
            String node = "/sys/class/thermal/thermal_message/sconfig";
            if (SysOps.sh("su -c 'test -f " + node + " && echo ok'").contains("ok")) {
                SysOps.sh("su -c 'echo " + v + " > " + node + "'");
                toast(R.string.thermal_applied);
            } else {
                toast(R.string.thermal_missing);
            }
            return true;
        });

        SwitchPreferenceCompat dnd = findPref("dnd_gaming");
        dnd.setOnPreferenceChangeListener((p, v) -> {
            SysOps.sh("cmd notification set_dnd " +
                    (((Boolean) v) ? "priority" : "off"));
            return true;
        });

        // ---------------- Maintenance ----------------
        prefClick("restart_ui", () -> SysOps.restartSystemUI());
        prefClick("trim_caches", () -> {
            SysOps.trimCaches();
            toast(R.string.trim_done);
        });
        prefClick("soft_reboot", () -> {
            try {
                PowerManager pm = (PowerManager)
                        ctx.getSystemService(Context.POWER_SERVICE);
                pm.reboot(null);
            } catch (Exception e) {
                SysOps.sh("su -c 'stop; start'");
            }
        });
    }

    // ---- helpers ------------------------------------------------------------

    private void anim(String key, String settingKey) {
        ListPreference lp = findPref(key);
        lp.setOnPreferenceChangeListener((p, v) -> {
            SysOps.putSystemFloat(getContext(), settingKey,
                    Float.parseFloat(v));
            return true;
        });
    }

    private void toggle(String key, String settingKey) {
        SwitchPreferenceCompat sw = findPref(key);
        sw.setOnPreferenceChangeListener((p, v) -> {
            SysOps.putSystemInt(getContext(), settingKey,
                    ((Boolean) v) ? 1 : 0);
            return true;
        });
    }

    private interface Cb { void go(); }

    private void prefClick(String key, Cb cb) {
        Preference p = findPref(key);
        p.setOnPreferenceClickListener(pref -> { cb.go(); return true; });
    }

    /** Pick an app, then a GameManager mode, then apply via `cmd game set`. */
    private void pickGameApp() {
        Intent i = new Intent(Intent.ACTION_MAIN).addCategory(
                Intent.CATEGORY_LAUNCHER);
        List<CharSequence> names = new ArrayList<>();
        List<String> pkgs = new ArrayList<>();
        for (android.content.pm.ResolveInfo ri :
                getContext().getPackageManager().queryIntentActivities(i, 0)) {
            String pkg = ri.activityInfo.packageName;
            if (pkg.equals(getContext().getPackageName())) continue;
            CharSequence label =
                    ri.loadLabel(getContext().getPackageManager());
            if (!names.contains(label)) {
                names.add(label);
                pkgs.add(pkg);
            }
        }
        new AlertDialog.Builder(getContext())
                .setTitle(R.string.pick_app)
                .setItems(names.toArray(new CharSequence[0]),
                        (d, which) -> pickMode(pkgs.get(which)))
                .show();
    }

    private void pickMode(final String pkg) {
        String[] labels = {
                getString(R.string.mode_performance),
                getString(R.string.mode_battery),
                getString(R.string.mode_default)};
        new AlertDialog.Builder(getContext())
                .setTitle(pkg)
                .setItems(labels, (d, which) -> {
                    int mode = which + 1; // 1 perf, 2 battery, 3 default
                    SysOps.sh("cmd game set --mode " + mode + " " + pkg);
                    prefs().edit().putString("gmode:" + pkg,
                            Integer.toString(mode)).apply();
                    toast(R.string.game_applied);
                }).show();
    }

    private SharedPreferences prefs() {
        return getContext().getSharedPreferences("pinfinity",
                Context.MODE_PRIVATE);
    }

    @SuppressWarnings("unchecked")
    private <T extends Preference> T findPref(String key) {
        return (T) findPreference(key);
    }

    private void toast(int resId) {
        Toast.makeText(getContext(), resId, Toast.LENGTH_SHORT).show();
    }
}
