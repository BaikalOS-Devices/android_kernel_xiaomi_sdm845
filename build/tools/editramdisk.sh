#!/sbin/sh

LD_PATH=/system/lib
if [ -d /system/lib64 ]; then
  LD_PATH=/system/lib64
fi

exec_util() {
  LD_LIBRARY_PATH=/system/lib64 $UTILS $1
}

set_con() {
  exec_util "chcon -h u:object_r:"$1":s0 $2"
  exec_util "chcon u:object_r:"$1":s0 $2"
}

CONFIGFILE="/tmp/anykernel/ramdisk/init.shadow.sh"
POSTBOOTFILE="/tmp/anykernel/ramdisk/init.qcom.post_boot.sh"
PROPFILE="/sdcard/shadow.prop"

rm $CONFIGFILE

if [ -f "$PROPFILE" ]; then

PROFILE=$(grep "CONFIG_SHADOW_PROFILE" "$PROPFILE" | cut -d '=' -f2)
FSYNC=$(grep "CONFIG_SHADOW_FSYNC" "$PROPFILE" | cut -d '=' -f2)
COLPROF=$(grep "CONFIG_SHADOW_COLPROF" "$PROPFILE" | cut -d '=' -f2)
USBFC=$(grep "CONFIG_SHADOW_USBFC" "$PROPFILE" | cut -d '=' -f2)
DT2W=$(grep "CONFIG_SHADOW_DT2W" "$PROPFILE" | cut -d '=' -f2)
ZRAM=$(grep "CONFIG_SHADOW_ZRAM" "$PROPFILE" | cut -d '=' -f2)
KLAPSE=$(grep "CONFIG_SHADOW_KLAPSE" "$PROPFILE" | cut -d '=' -f2)
DIM=$(grep "CONFIG_SHADOW_DIM" "$PROPFILE" | cut -d '=' -f2)


else

PROFILE=0
FSYNC=1
COLPROF=0
USBFC=0
DT2W=0
ZRAM=1
KLAPSE=0
DIM=0

echo "# Shadow Kernel Properties" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Change values to customize kernel defaults during installation" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Profile - Profiles according to your needs" >> $PROPFILE
echo "# 0 - Balanced, 1 - Performance, 2 - Battery, 3 - BattPerf" >> $PROPFILE
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
echo "# zRAM - Increases performance by using a compressed block device" >> $PROPFILE
echo "# 0 - Off, 1 - On" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_ZRAM=1" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# K-Lapse - A kernel level livedisplay module" >> $PROPFILE
echo "# 0 - Off, 1 - On (Night Mode), 2 - On (Brightness Mode)" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_KLAPSE=0" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE
echo "# Dimmer - Makes your display appear as if it is at a lesser brightness level than it actually is at" >> $PROPFILE
echo "# Values - 10,20,30,40,50,60,70,80,90,100 : 10 - Lowest Intensity, 100/0 - Default" >> $PROPFILE
echo "" >> $PROPFILE
echo "CONFIG_SHADOW_DIM=0" >> $PROPFILE
echo "" >> $PROPFILE
echo "" >> $PROPFILE

fi

if [ ! -d $ramdisk/.backup ]; then
echo "#! /vendor/bin/sh" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "# Copyright (c) 2012-2013, 2016-2018, The Linux Foundation. All rights reserved." >> $POSTBOOTFILE
echo "#" >> $POSTBOOTFILE
echo "# Redistribution and use in source and binary forms, with or without" >> $POSTBOOTFILE
echo "# modification, are permitted provided that the following conditions are met:" >> $POSTBOOTFILE
echo "#     * Redistributions of source code must retain the above copyright" >> $POSTBOOTFILE
echo "#       notice, this list of conditions and the following disclaimer." >> $POSTBOOTFILE
echo "#     * Redistributions in binary form must reproduce the above copyright" >> $POSTBOOTFILE
echo "#       notice, this list of conditions and the following disclaimer in the" >> $POSTBOOTFILE
echo "#       documentation and/or other materials provided with the distribution." >> $POSTBOOTFILE
echo "#     * Neither the name of The Linux Foundation nor" >> $POSTBOOTFILE
echo "#       the names of its contributors may be used to endorse or promote" >> $POSTBOOTFILE
echo "#       products derived from this software without specific prior written" >> $POSTBOOTFILE
echo "#       permission." >> $POSTBOOTFILE
echo "#" >> $POSTBOOTFILE
echo "# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"" >> $POSTBOOTFILE
echo "# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE" >> $POSTBOOTFILE
echo "# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND" >> $POSTBOOTFILE
echo "# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR" >> $POSTBOOTFILE
echo "# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL," >> $POSTBOOTFILE
echo "# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO," >> $POSTBOOTFILE
echo "# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;" >> $POSTBOOTFILE
echo "# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY," >> $POSTBOOTFILE
echo "# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR" >> $POSTBOOTFILE
echo "# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF" >> $POSTBOOTFILE
echo "# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE." >> $POSTBOOTFILE
echo "#" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "function start_hbtp()" >> $POSTBOOTFILE
echo "{" >> $POSTBOOTFILE
echo "        # Start the Host based Touch processing but not in the power off mode." >> $POSTBOOTFILE
echo "        bootmode=\`getprop ro.bootmode\`" >> $POSTBOOTFILE
echo "        if [ \"charger\" != \$bootmode ]; then" >> $POSTBOOTFILE
echo "                start vendor.hbtp" >> $POSTBOOTFILE
echo "        fi" >> $POSTBOOTFILE
echo "}" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "        # Set the default IRQ affinity to the silver cluster. When a" >> $POSTBOOTFILE
echo "        # CPU is isolated/hotplugged, the IRQ affinity is adjusted" >> $POSTBOOTFILE
echo "        # to one of the CPU from the default IRQ affinity mask." >> $POSTBOOTFILE
echo "        echo f > /proc/irq/default_smp_affinity" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	start_hbtp" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	# Core control parameters" >> $POSTBOOTFILE
echo "	echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres" >> $POSTBOOTFILE
echo "	echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres" >> $POSTBOOTFILE
echo "	echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms" >> $POSTBOOTFILE
echo "	echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster" >> $POSTBOOTFILE
echo "	echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	# Setting b.L scheduler parameters" >> $POSTBOOTFILE
echo "	echo 95 > /proc/sys/kernel/sched_upmigrate" >> $POSTBOOTFILE
echo "	echo 85 > /proc/sys/kernel/sched_downmigrate" >> $POSTBOOTFILE
echo "	echo 100 > /proc/sys/kernel/sched_group_upmigrate" >> $POSTBOOTFILE
echo "	echo 95 > /proc/sys/kernel/sched_group_downmigrate" >> $POSTBOOTFILE
echo "	echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	# configure governor settings for little cluster" >> $POSTBOOTFILE
echo "	echo \"schedutil\" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $POSTBOOTFILE
echo "	echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/rate_limit_us" >> $POSTBOOTFILE
echo "	echo 1209600 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq" >> $POSTBOOTFILE
echo "	echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/pl" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	# configure governor settings for big cluster" >> $POSTBOOTFILE
echo "	echo \"schedutil\" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor" >> $POSTBOOTFILE
echo "	echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/rate_limit_us" >> $POSTBOOTFILE
echo "	echo 1574400 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq" >> $POSTBOOTFILE
echo "	echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/pl" >> $POSTBOOTFILE
echo "	echo \"0:0 1:0 2:0 3:0 4:2323200 5:0 6:0 7:0\" > /sys/module/cpu_boost/parameters/powerkey_input_boost_freq" >> $POSTBOOTFILE
echo "	echo 400 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	# Shadow Changes" >> $POSTBOOTFILE
case $PROFILE in
    1)
	echo "	echo 576000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 1766400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 2803200 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus" >> $POSTBOOTFILE
	echo "	echo \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\" > /sys/module/cpu_boost/parameters/input_boost_freq" >> $POSTBOOTFILE
	echo "	echo 250 > /sys/module/cpu_boost/parameters/input_boost_ms" >> $POSTBOOTFILE
	echo "	echo 5 > /sys/module/cpu_boost/parameters/dynamic_stune_boost" >> $POSTBOOTFILE
	echo "	echo 60 > /proc/sys/vm/swappiness" >> $POSTBOOTFILE
	echo "	echo 100 > /proc/sys/vm/vfs_cache_pressure" >> $POSTBOOTFILE
	echo "	echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" >> $POSTBOOTFILE
	echo "	echo 10 > /sys/class/thermal/thermal_message/sconfig" >> $POSTBOOTFILE
	;;
    2)
	echo "	echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 1766400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 2323200 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus" >> $POSTBOOTFILE
	echo "	echo \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\" > /sys/module/cpu_boost/parameters/input_boost_freq" >> $POSTBOOTFILE
	echo "	echo 30 > /sys/module/cpu_boost/parameters/input_boost_ms" >> $POSTBOOTFILE
	echo "	echo 0 > /sys/module/cpu_boost/parameters/dynamic_stune_boost" >> $POSTBOOTFILE
	echo "	echo 20 > /proc/sys/vm/swappiness" >> $POSTBOOTFILE
	echo "	echo 40 > /proc/sys/vm/vfs_cache_pressure" >> $POSTBOOTFILE
	echo "	echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" >> $POSTBOOTFILE
	echo "	echo 10 > /sys/class/thermal/thermal_message/sconfig" >> $POSTBOOTFILE
	;;
    3)
	echo "	echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 1766400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 1766400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus" >> $POSTBOOTFILE
	echo "	echo \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\" > /sys/module/cpu_boost/parameters/input_boost_freq" >> $POSTBOOTFILE
	echo "	echo 250 > /sys/module/cpu_boost/parameters/input_boost_ms" >> $POSTBOOTFILE
	echo "	echo 5 > /sys/module/cpu_boost/parameters/dynamic_stune_boost" >> $POSTBOOTFILE
	echo "	echo 60 > /proc/sys/vm/swappiness" >> $POSTBOOTFILE
	echo "	echo 100 > /proc/sys/vm/vfs_cache_pressure" >> $POSTBOOTFILE
	echo "	echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" >> $POSTBOOTFILE
	echo "	echo 11 > /sys/class/thermal/thermal_message/sconfig" >> $POSTBOOTFILE
	;;
    *)
	echo "	echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $POSTBOOTFILE
	echo "	echo 1766400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 2803200 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $POSTBOOTFILE
	echo "	echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus" >> $POSTBOOTFILE
	echo "	echo \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\" > /sys/module/cpu_boost/parameters/input_boost_freq" >> $POSTBOOTFILE
	echo "	echo 64 > /sys/module/cpu_boost/parameters/input_boost_ms" >> $POSTBOOTFILE
	echo "	echo 3 > /sys/module/cpu_boost/parameters/dynamic_stune_boost" >> $POSTBOOTFILE
	echo "	echo 40 > /proc/sys/vm/swappiness" >> $POSTBOOTFILE
	echo "	echo 100 > /proc/sys/vm/vfs_cache_pressure" >> $POSTBOOTFILE
	echo "	echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" >> $POSTBOOTFILE
	echo "	echo 10 > /sys/class/thermal/thermal_message/sconfig" >> $POSTBOOTFILE
esac
echo "" >> $POSTBOOTFILE
echo "        # Enable oom_reaper" >> $POSTBOOTFILE
echo "        echo 1 > /sys/module/lowmemorykiller/parameters/oom_reaper" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "        # Enable bus-dcvs" >> $POSTBOOTFILE
echo "        for cpubw in /sys/class/devfreq/*qcom,cpubw*" >> $POSTBOOTFILE
echo "        do" >> $POSTBOOTFILE
echo "            echo \"bw_hwmon\" > \$cpubw/governor" >> $POSTBOOTFILE
echo "            echo 50 > \$cpubw/polling_interval" >> $POSTBOOTFILE
echo "            echo \"2288 4577 6500 8132 9155 10681\" > \$cpubw/bw_hwmon/mbps_zones" >> $POSTBOOTFILE
echo "            echo 4 > \$cpubw/bw_hwmon/sample_ms" >> $POSTBOOTFILE
echo "            echo 50 > \$cpubw/bw_hwmon/io_percent" >> $POSTBOOTFILE
echo "            echo 20 > \$cpubw/bw_hwmon/hist_memory" >> $POSTBOOTFILE
echo "            echo 10 > \$cpubw/bw_hwmon/hyst_length" >> $POSTBOOTFILE
echo "            echo 0 > \$cpubw/bw_hwmon/guard_band_mbps" >> $POSTBOOTFILE
echo "            echo 250 > \$cpubw/bw_hwmon/up_scale" >> $POSTBOOTFILE
echo "            echo 1600 > \$cpubw/bw_hwmon/idle_mbps" >> $POSTBOOTFILE
echo "        done" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "        for llccbw in /sys/class/devfreq/*qcom,llccbw*" >> $POSTBOOTFILE
echo "        do" >> $POSTBOOTFILE
echo "            echo \"bw_hwmon\" > \$llccbw/governor" >> $POSTBOOTFILE
echo "            echo 50 > \$llccbw/polling_interval" >> $POSTBOOTFILE
echo "            echo \"1720 2929 3879 5931 6881\" > $llccbw/bw_hwmon/mbps_zones" >> $POSTBOOTFILE
echo "            echo 4 > \$llccbw/bw_hwmon/sample_ms" >> $POSTBOOTFILE
echo "            echo 80 > \$llccbw/bw_hwmon/io_percent" >> $POSTBOOTFILE
echo "            echo 20 > \$llccbw/bw_hwmon/hist_memory" >> $POSTBOOTFILE
echo "            echo 10 > \$llccbw/bw_hwmon/hyst_length" >> $POSTBOOTFILE
echo "            echo 0 > \$llccbw/bw_hwmon/guard_band_mbps" >> $POSTBOOTFILE
echo "            echo 250 > \$llccbw/bw_hwmon/up_scale" >> $POSTBOOTFILE
echo "            echo 1600 > \$llccbw/bw_hwmon/idle_mbps" >> $POSTBOOTFILE
echo "        done" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	#Enable mem_latency governor for DDR scaling" >> $POSTBOOTFILE
echo "        for memlat in /sys/class/devfreq/*qcom,memlat-cpu*" >> $POSTBOOTFILE
echo "        do" >> $POSTBOOTFILE
echo "	echo \"mem_latency\" > \$memlat/governor" >> $POSTBOOTFILE
echo "            echo 10 > \$memlat/polling_interval" >> $POSTBOOTFILE
echo "            echo 400 > \$memlat/mem_latency/ratio_ceil" >> $POSTBOOTFILE
echo "        done" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	#Enable mem_latency governor for L3 scaling" >> $POSTBOOTFILE
echo "        for memlat in /sys/class/devfreq/*qcom,l3-cpu*" >> $POSTBOOTFILE
echo "        do" >> $POSTBOOTFILE
echo "            echo \"mem_latency\" > \$memlat/governor" >> $POSTBOOTFILE
echo "            echo 10 > \$memlat/polling_interval" >> $POSTBOOTFILE
echo "            echo 400 > \$memlat/mem_latency/ratio_ceil" >> $POSTBOOTFILE
echo "        done" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "        #Enable userspace governor for L3 cdsp nodes" >> $POSTBOOTFILE
echo "        for l3cdsp in /sys/class/devfreq/*qcom,l3-cdsp*" >> $POSTBOOTFILE
echo "        do" >> $POSTBOOTFILE
echo "            echo \"userspace\" > \$l3cdsp/governor" >> $POSTBOOTFILE
echo "            chown -h system \$l3cdsp/userspace/set_freq" >> $POSTBOOTFILE
echo "        done" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	#Gold L3 ratio ceil" >> $POSTBOOTFILE
echo "        echo 4000 > /sys/class/devfreq/soc:qcom,l3-cpu4/mem_latency/ratio_ceil" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	echo \"compute\" > /sys/class/devfreq/soc:qcom,mincpubw/governor" >> $POSTBOOTFILE
echo "	echo 10 > /sys/class/devfreq/soc:qcom,mincpubw/polling_interval" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	# cpuset parameters" >> $POSTBOOTFILE
echo "        echo 0-1 > /dev/cpuset/background/cpus" >> $POSTBOOTFILE
echo "        echo 0-2 > /dev/cpuset/system-background/cpus" >> $POSTBOOTFILE
echo "        echo 4-7 > /dev/cpuset/foreground/boost/cpus" >> $POSTBOOTFILE
echo "        echo 0-2,4-7 > /dev/cpuset/foreground/cpus" >> $POSTBOOTFILE
echo "        echo 0-7 > /dev/cpuset/top-app/cpus" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "	# Turn off scheduler boost at the end" >> $POSTBOOTFILE
echo "        echo 0 > /proc/sys/kernel/sched_boost" >> $POSTBOOTFILE
echo "	# Disable CPU Retention" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu0/ret/idle_enabled" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu1/ret/idle_enabled" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu2/ret/idle_enabled" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu3/ret/idle_enabled" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu4/ret/idle_enabled" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu5/ret/idle_enabled" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu6/ret/idle_enabled" >> $POSTBOOTFILE
echo "        echo N > /sys/module/lpm_levels/L3/cpu7/ret/idle_enabled" >> $POSTBOOTFILE
echo "	echo N > /sys/module/lpm_levels/L3/l3-dyn-ret/idle_enabled" >> $POSTBOOTFILE
echo "        # Turn on sleep modes." >> $POSTBOOTFILE
echo "        echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled" >> $POSTBOOTFILE
echo "	echo 100 > /proc/sys/vm/swappiness" >> $POSTBOOTFILE
echo "	echo 120 > /proc/sys/vm/watermark_scale_factor" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "        # set lmk minfree for MemTotal greater than 6G" >> $POSTBOOTFILE
echo "	arch_type=\`uname -m\`" >> $POSTBOOTFILE
echo "	MemTotalStr=\`cat /proc/meminfo | grep MemTotal\`" >> $POSTBOOTFILE
echo "	MemTotal=\${MemTotalStr:16:8}" >> $POSTBOOTFILE
echo "	if [ \"\$arch_type\" == \"aarch64\" ] && [ \$MemTotal -gt 5505024 ]; then" >> $POSTBOOTFILE
echo "	    echo \"18432,23040,27648,32256,85296,120640\" > /sys/module/lowmemorykiller/parameters/minfree" >> $POSTBOOTFILE
echo "	fi" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "        setprop vendor.post_boot.parsed 1" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "# Let kernel know our image version/variant/crm_version" >> $POSTBOOTFILE
echo "if [ -f /sys/devices/soc0/select_image ]; then" >> $POSTBOOTFILE
echo "    image_version=\"10:\"" >> $POSTBOOTFILE
echo "    image_version+=\`getprop ro.build.id\`" >> $POSTBOOTFILE
echo "    image_version+=\":\"" >> $POSTBOOTFILE
echo "    image_version+=\`getprop ro.build.version.incremental\`" >> $POSTBOOTFILE
echo "    image_variant=\`getprop ro.product.name\`" >> $POSTBOOTFILE
echo "    image_variant+=\"-\"" >> $POSTBOOTFILE
echo "    image_variant+=\`getprop ro.build.type\`" >> $POSTBOOTFILE
echo "    oem_version=\`getprop ro.build.version.codename\`" >> $POSTBOOTFILE
echo "    echo 10 > /sys/devices/soc0/select_image" >> $POSTBOOTFILE
echo "    echo \$image_version > /sys/devices/soc0/image_version" >> $POSTBOOTFILE
echo "    echo \$image_variant > /sys/devices/soc0/image_variant" >> $POSTBOOTFILE
echo "    echo \$oem_version > /sys/devices/soc0/image_crm_version" >> $POSTBOOTFILE
echo "fi" >> $POSTBOOTFILE
echo "" >> $POSTBOOTFILE
echo "# Parse misc partition path and set property" >> $POSTBOOTFILE
echo "misc_link=\$(ls -l /dev/block/bootdevice/by-name/misc)" >> $POSTBOOTFILE
echo "real_path=\${misc_link##*>}" >> $POSTBOOTFILE
echo "setprop persist.vendor.mmi.misc_dev_path \$real_path" >> $POSTBOOTFILE
else
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
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"schedutil\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor \"schedutil\"" >> $CONFIGFILE
echo "" >> $CONFIGFILE

case $PROFILE in
    1)
	echo "# Profile - Performance" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1766400" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2803200" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 576000" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 825600" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\"" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_ms 250" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/dynamic_stune_boost 5" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 2" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 710000000" >> $CONFIGFILE
	echo "write /proc/sys/vm/swappiness 60" >> $CONFIGFILE
	echo "write /proc/sys/vm/vfs_cache_pressure 100" >> $CONFIGFILE
	echo "write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0" >> $CONFIGFILE
	echo "write /sys/class/thermal/thermal_message/sconfig 10" >> $CONFIGFILE
        ;;
    2)
	echo "# Profile - Battery" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1766400" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2323200" >> $CONFIGFILE
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
	echo "write /sys/class/thermal/thermal_message/sconfig 10" >> $CONFIGFILE
        ;;
    3)
	echo "# Profile - BattPerf" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1766400" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1766400" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 576000" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 825600" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\"" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_ms 64" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/dynamic_stune_boost 3" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 1" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 710000000" >> $CONFIGFILE
	echo "write /proc/sys/vm/swappiness 60" >> $CONFIGFILE
	echo "write /proc/sys/vm/vfs_cache_pressure 100" >> $CONFIGFILE
	echo "write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 1" >> $CONFIGFILE
	echo "write /sys/class/thermal/thermal_message/sconfig 11" >> $CONFIGFILE
        ;;
    *)
	echo "# Profile - Balanced" >> $CONFIGFILE
	echo "" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1766400" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2803200" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 825600" >> $CONFIGFILE
	echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0\"" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/input_boost_ms 64" >> $CONFIGFILE
	echo "write /sys/module/cpu_boost/parameters/dynamic_stune_boost 3" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $CONFIGFILE
	echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 1" >> $CONFIGFILE
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

if [ $ZRAM = 0 ]; then
echo "# zRAM" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "system/bin/swapoff /dev/block/zram0" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE
fi

echo "# K-Lapse" >> $CONFIGFILE
echo "" >> $CONFIGFILE
case $KLAPSE in
    1)
	echo "write /sys/module/klapse/parameters/enabled_mode 1" >> $CONFIGFILE
	;;
    2)
	echo "write /sys/module/klapse/parameters/enabled_mode 2" >> $CONFIGFILE
	;;
    *)
	echo "write /sys/module/klapse/parameters/enabled_mode 0" >> $CONFIGFILE
esac
echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "# Dimmer" >> $CONFIGFILE
echo "" >> $CONFIGFILE
case $DIM in
    10)
	echo "write /sys/module/klapse/parameters/dimmer_factor 10" >> $CONFIGFILE
	;;
    20)
	echo "write /sys/module/klapse/parameters/dimmer_factor 20" >> $CONFIGFILE
	;;
    30)
	echo "write /sys/module/klapse/parameters/dimmer_factor 30" >> $CONFIGFILE
	;;
    40)
	echo "write /sys/module/klapse/parameters/dimmer_factor 40" >> $CONFIGFILE
	;;
    50)
	echo "write /sys/module/klapse/parameters/dimmer_factor 50" >> $CONFIGFILE
	;;
    60)
	echo "write /sys/module/klapse/parameters/dimmer_factor 60" >> $CONFIGFILE
	;;
    70)
	echo "write /sys/module/klapse/parameters/dimmer_factor 70" >> $CONFIGFILE
	;;
    80)
	echo "write /sys/module/klapse/parameters/dimmer_factor 80" >> $CONFIGFILE
	;;
    90)
	echo "write /sys/module/klapse/parameters/dimmer_factor 90" >> $CONFIGFILE
	;;
    *)
	echo "write /sys/module/klapse/parameters/dimmer_factor 100" >> $CONFIGFILE
esac
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
fi

# Ship fstab with f2fs mount points and flags
ui_print " "; ui_print "Shipping modified fstab with f2fs mount points...";
umount /vendor || true
mount -o rw /dev/block/bootdevice/by-name/vendor /vendor
chmod -R 640 /tmp/anykernel/ramdisk/fstab.qcom;
exec_util "cp -a /tmp/anykernel/ramdisk/fstab.qcom /vendor/etc/"
rm $ramdisk/fstab.qcom
if [ ! -d $ramdisk/.backup ]; then
chmod -R 755 /tmp/anykernel/ramdisk/init.qcom.post_boot.sh;
chown -R root:root /tmp/anykernel/ramdisk/init.qcom.post_boot.sh;
ui_print " "; ui_print "Your device is not rooted so modifying qcom_post_boot...";
ui_print "shadow.prop functionality will be limited to profiles only...";
exec_util "cp -a /tmp/anykernel/ramdisk/init.qcom.post_boot.sh /vendor/bin/"
set_con qti_init_shell_exec /vendor/bin/init.qcom.post_boot.sh
rm $ramdisk/init.qcom.post_boot.sh
fi
umount /vendor || true


# Set Permissions
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;
