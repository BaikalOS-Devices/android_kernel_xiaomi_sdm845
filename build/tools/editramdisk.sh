#!/sbin/sh

CONFIGFILE="/tmp/anykernel/ramdisk/init.shadow.sh"
PROPFILE="/sdcard/shadow.prop"

rm $CONFIGFILE

if [ -f "$PROPFILE" ]; then

PROFILE=$(grep "CONFIG_SHADOW_PROFILE" "$PROPFILE" | cut -d '=' -f2)
FSYNC=$(grep "CONFIG_SHADOW_FSYNC" "$PROPFILE" | cut -d '=' -f2)
COLPROF=$(grep "CONFIG_SHADOW_COLPROF" "$PROPFILE" | cut -d '=' -f2)
USBFC=$(grep "CONFIG_SHADOW_USBFC" "$PROPFILE" | cut -d '=' -f2)
DT2W=$(grep "CONFIG_SHADOW_DT2W" "$PROPFILE" | cut -d '=' -f2)

else

PROFILE=0
FSYNC=1
COLPROF=0
USBFC=0
DT2W=0

echo "# Shadow Kernel Properties" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Change values to customize kernel defaults during installation" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Profile - Profiles according to your needs" >> $PROPFILE
echo "# 0 - Balanced, 1 - Performance, 2 - Battery" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_PROFILE=0" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Fsync - Turn off for more performance at risk of data loss" >> $PROPFILE
echo "# 0 - Off, 1 - On" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_FSYNC=1" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Color Profiles - Tweak your display colors" >> $PROPFILE
echo "# 0 - Default, 1 - Warm, 2 - Cool, 3 - Vivid" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_COLPROF=0" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# USB Fast Charge - When enabled draws 900ma instead of 500ma when connected via USB" >> $PROPFILE
echo "# 0 - Off, 1 - On" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_USBFC=0" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Double Tap to Wake - Used to wake device by double tapping on screen" >> $PROPFILE
echo "# 0 - Off, 1 - On" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_DT2W=0" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE

fi

echo "#!/system/bin/sh" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "################################################################################" >> $CONFIGFILE
echo "# helper functions to allow Android init like script" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "function write() {" >> $CONFIGFILE
echo "    echo -n \$2 > \$1" >> $CONFIGFILE
echo "}" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "function copy() {" >> $CONFIGFILE
echo "    cat \$1 > \$2" >> $CONFIGFILE
echo "}" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# macro to write pids to system-background cpuset" >> $CONFIGFILE
echo "function writepid_sbg() {" >> $CONFIGFILE
echo "    until [ ! \"\$1\" ]; do" >> $CONFIGFILE
echo "        echo -n \$1 > /dev/cpuset/system-background/tasks;" >> $CONFIGFILE
echo "        shift;" >> $CONFIGFILE
echo "    done;" >> $CONFIGFILE
echo "}" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "################################################################################" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "{" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "sleep 10;" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"pixutil\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor \"pixutil\"" >> $CONFIGFILE
echo "" >> $CONFIGFILE

case $PROFILE in
    1)
	echo "# Profile - Performance" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1766400" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2803200" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 576000" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 825600" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 2" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\"" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_ms 250" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/dynamic_stune_boost 5" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 1" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 710000000" >> $CONFIGFILE
	echo "write /proc/sys/vm/swappiness 60" >> $CONFIGFILE
	echo "write /proc/sys/vm/vfs_cache_pressure 100" >> $CONFIGFILE
	echo "write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0" >> $CONFIGFILE
	echo "write /sys/class/thermal/thermal_message/sconfig 10" >> $CONFIGFILE
        ;;
    2)
	echo "# Profile - Battery" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1516800" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1536000" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 825600" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\"" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_ms 30" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/dynamic_stune_boost 0" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 0" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 596000000" >> $CONFIGFILE
	echo "write /proc/sys/vm/swappiness 20" >> $CONFIGFILE
	echo "write /proc/sys/vm/vfs_cache_pressure 40" >> $CONFIGFILE
	echo "write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 1" >> $CONFIGFILE
	echo "write /sys/class/thermal/thermal_message/sconfig 11" >> $CONFIGFILE
        ;;
    *)
	echo "# Profile - Balanced" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1766400" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2323200" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 825600" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\"" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_ms 64" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/dynamic_stune_boost 0" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 0" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 710000000" >> $CONFIGFILE
	echo "write /proc/sys/vm/swappiness 40" >> $CONFIGFILE
	echo "write /proc/sys/vm/vfs_cache_pressure 100" >> $CONFIGFILE
	echo "write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 1" >> $CONFIGFILE
	echo "write /sys/class/thermal/thermal_message/sconfig 10" >> $CONFIGFILE
esac

echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# Fsync" >> $CONFIGFILE
echo "" >> $CONFIGFILE
if [ $FSYNC = 1 ]; then
echo "write /sys/module/sync/parameters/fsync_enabled 1" >> $CONFIGFILE
else
echo "write /sys/module/sync/parameters/fsync_enabled 0" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE

case $COLPROF in
    1)
	echo "# Color Profile - Warm" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_sat 269" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_val 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_cont 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_red 254" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_green 252" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_blue 230" >> $CONFIGFILE
        ;;
    2)
	echo "# Color Profile - Cool" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_sat 269" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_val 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_cont 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_red 254" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_green 254" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_blue 240" >> $CONFIGFILE
        ;;
    3)
	echo "# Color Profile - Vivid" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_sat 270" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_val 257" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_cont 265" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_red 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_green 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_blue 256" >> $CONFIGFILE
        ;;
    *)
	echo "# Color Profile - Default" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_sat 255" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_val 255" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_cont 255" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_red 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_green 256" >> $CONFIGFILE
	echo "write /sys/module/msm_drm/parameters/kcal_blue 256" >> $CONFIGFILE
esac

echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# USB Fast Charge" >> $CONFIGFILE
echo "" >> $CONFIGFILE
if [ $USBFC = 1 ]; then
echo "write /sys/kernel/fast_charge/force_fast_charge 1" >> $CONFIGFILE
else
echo "write /sys/kernel/fast_charge/force_fast_charge 0" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# Double Tap to Wake" >> $CONFIGFILE
echo "" >> $CONFIGFILE
if [ $DT2W = 1 ]; then
echo "write /proc/touchpanel/wake_gesture 1" >> $CONFIGFILE
else
echo "write /proc/touchpanel/wake_gesture 0" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "# Set the default IRQ affinity to the silver cluster." >> $CONFIGFILE
echo "write /proc/irq/default_smp_affinity f" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# Set I/O Values" >> $CONFIGFILE
echo "write /sys/block/sda/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/sda/queue/nr_requests 128" >> $CONFIGFILE
echo "write /sys/block/sda/queue/iostats 1" >> $CONFIGFILE
echo "write /sys/block/sda/queue/scheduler bfq" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "write /sys/block/sde/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/sde/queue/nr_requests 128" >> $CONFIGFILE
echo "write /sys/block/sde/queue/iostats 1" >> $CONFIGFILE
echo "write /sys/block/sde/queue/scheduler bfq" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "write /sys/block/dm-0/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/dm-0/queue/nr_requests 128" >> $CONFIGFILE
echo "write /sys/block/dm-0/queue/iostats 1" >> $CONFIGFILE
echo "write /sys/block/dm-0/queue/scheduler bfq" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/nr_requests 128" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/iostats 1" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/scheduler bfq" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "sleep 20;" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "QSEECOMD=\`pidof qseecomd\`" >> $CONFIGFILE
echo "THERMAL_ENGINE=\`pidof thermal-engine\`" >> $CONFIGFILE
echo "TIME_DAEMON=\`pidof time_daemon\`" >> $CONFIGFILE
echo "IMSQMIDAEMON=\`pidof imsqmidaemon\`" >> $CONFIGFILE
echo "IMSDATADAEMON=\`pidof imsdatadaemon\`" >> $CONFIGFILE
echo "DASHD=\`pidof dashd\`" >> $CONFIGFILE
echo "CND=\`pidof cnd\`" >> $CONFIGFILE
echo "DPMD=\`pidof dpmd\`" >> $CONFIGFILE
echo "RMT_STORAGE=\`pidof rmt_storage\`" >> $CONFIGFILE
echo "TFTP_SERVER=\`pidof tftp_server\`" >> $CONFIGFILE
echo "NETMGRD=\`pidof netmgrd\`" >> $CONFIGFILE
echo "IPACM=\`pidof ipacm\`" >> $CONFIGFILE
echo "QTI=\`pidof qti\`" >> $CONFIGFILE
echo "LOC_LAUNCHER=\`pidof loc_launcher\`" >> $CONFIGFILE
echo "QSEEPROXYDAEMON=\`pidof qseeproxydaemon\`" >> $CONFIGFILE
echo "IFAADAEMON=\`pidof ifaadaemon\`" >> $CONFIGFILE
echo "LOGCAT=\`pidof logcat\`" >> $CONFIGFILE
echo "LMKD=\`pidof lmkd\`" >> $CONFIGFILE
echo "PERFD=\`pidof perfd\`" >> $CONFIGFILE
echo "IOP=\`pidof iop\`" >> $CONFIGFILE
echo "MSM_IRQBALANCE=\`pidof msm_irqbalance\`" >> $CONFIGFILE
echo "SEEMP_HEALTHD=\`pidof seemp_healthd\`" >> $CONFIGFILE
echo "ESEPMDAEMON=\`pidof esepmdaemon\`" >> $CONFIGFILE
echo "WPA_SUPPLICANT=\`pidof wpa_supplicant\`" >> $CONFIGFILE
echo "SEEMPD=\`pidof seempd\`" >> $CONFIGFILE
echo "EMBRYO=\`pidof embryo\`" >> $CONFIGFILE
echo "HEALTHD=\`pidof healthd\`" >> $CONFIGFILE
echo "OEMLOGKIT=\`pidof oemlogkit\`" >> $CONFIGFILE
echo "NETD=\`pidof netd\`" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "writepid_sbg \$QSEECOMD;" >> $CONFIGFILE
echo "writepid_sbg \$THERMAL_ENGINE;" >> $CONFIGFILE
echo "writepid_sbg \$TIME_DAEMON;" >> $CONFIGFILE
echo "writepid_sbg \$IMSQMIDAEMON;" >> $CONFIGFILE
echo "writepid_sbg \$IMSDATADAEMON;" >> $CONFIGFILE
echo "writepid_sbg \$DASHD;" >> $CONFIGFILE
echo "writepid_sbg \$CND;" >> $CONFIGFILE
echo "writepid_sbg \$DPMD;" >> $CONFIGFILE
echo "writepid_sbg \$RMT_STORAGE;" >> $CONFIGFILE
echo "writepid_sbg \$TFTP_SERVER;" >> $CONFIGFILE
echo "writepid_sbg \$NETMGRD;" >> $CONFIGFILE
echo "writepid_sbg \$IPACM;" >> $CONFIGFILE
echo "writepid_sbg \$QTI;" >> $CONFIGFILE
echo "writepid_sbg \$LOC_LAUNCHER;" >> $CONFIGFILE
echo "writepid_sbg \$QSEEPROXYDAEMON;" >> $CONFIGFILE
echo "writepid_sbg \$IFAADAEMON;" >> $CONFIGFILE
echo "writepid_sbg \$LOGCAT;" >> $CONFIGFILE
echo "writepid_sbg \$LMKD;" >> $CONFIGFILE
echo "writepid_sbg \$PERFD;" >> $CONFIGFILE
echo "writepid_sbg \$IOP;" >> $CONFIGFILE
echo "writepid_sbg \$MSM_IRQBALANCE;" >> $CONFIGFILE
echo "writepid_sbg \$SEEMP_HEALTHD;" >> $CONFIGFILE
echo "writepid_sbg \$ESEPMDAEMON;" >> $CONFIGFILE
echo "writepid_sbg \$WPA_SUPPLICANT;" >> $CONFIGFILE
echo "writepid_sbg \$SEEMPD;" >> $CONFIGFILE
echo "writepid_sbg \$HEALTHD;" >> $CONFIGFILE
echo "writepid_sbg \$OEMLOGKIT;" >> $CONFIGFILE
echo "writepid_sbg \$NETD;" >> $CONFIGFILE
echo "}&" >> $CONFIGFILE


# Set Permissions
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;
