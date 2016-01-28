#!/sbin/sh
#
# Panel Detection Script - Authored by dr87 & maintained by Rashed97 feat. Zdrowy Gosciu
#
# Detect panel and swap as necessary 
# lcd_maker_id is determined by get_panel_maker_id on the hardware and is always accurate
# This searches directly in the boot.img and has no other requirements
# Do not shorten the search or you may change the actual kernel source
#
#	LCD_RENESAS_LGD = 0,
#	LCD_RENESAS_JDI = 1
#
# Look for qcom,dsi-pref-prim-pan in DTS
#

lcdmaker=$(grep -c "lcd_maker_id=1" /proc/cmdline)
if [ "$lcdmaker" == "1" ]; then
	echo "JDI panel detected.. Swapping.."
	find /tmp/boot.img -type f -exec sed -i 's/mdss_mdp.panel=1:dsi:0:qcom,mdss_dsi_g2_lgd_cmd/mdss_mdp.panel=1:dsi:0:qcom,mdss_dsi_g2_jdi_cmd/g' {} \;
elif [ "$lcdmaker" == "0" ]; then
	echo "LGD panel detected.. Already included.."
else
	echo "lcd_maker_id doesn't exist. Something went wrong."
fi

#
# Setup HH CPU max freq
#

if [ -f /data/property/persist.hh.maxfreq ]; then
	echo "persist.hh.maxfreq already exists.. Skipping.."
else
	echo -n 0 > /data/property/persist.hh.maxfreq
	chmod 0600 /data/property/persist.hh.maxfreq
fi
