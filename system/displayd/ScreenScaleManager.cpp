#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <cutils/properties.h>
#define LOG_TAG "ScreenScaleManager"
#include <cutils/log.h>
#include "Config.h"
#include "ScreenScaleManager.h"


#define PROPETY_SCALE_X			"persist.sys.scalerate_x"
#define PROPETY_SCALE_Y			"persist.sys.scalerate_y"
#define MAIN_DISPLAY_SCALE_FILE	"/sys/class/graphics/fb0/scale"
#define AUX_DISPLAY_SCALE_FILE	"/sys/class/graphics/fb2/scale"

struct scaleinfo {
	int xrate;		// screen scale rate in x direction
	int yrate;		// screen scale rate in y direction
};

ScreenScaleManager::ScreenScaleManager() {
	InitSysNode();
	char property[PROPERTY_VALUE_MAX];
	int scalevalue = DEFALUT_SCREEN_SCALE;
    if (property_get(PROPETY_SCALE_X, property, NULL) > 0) {
    	scalevalue = atoi(property);
    }
    if(scalevalue == 0)
    	scalevalue = DEFALUT_SCREEN_SCALE;
    SSMCtrlX(0, scalevalue);
    if (property_get(PROPETY_SCALE_Y, property, NULL) > 0) {
    	scalevalue = atoi(property);
    }
    if(scalevalue == 0)
    	scalevalue = DEFALUT_SCREEN_SCALE;
    SSMCtrlY(0, scalevalue);
}

void ScreenScaleManager::InitSysNode(void) {
	memset(MainDisplaySysNode, 0, 64);
	memset(AuxDisplaySysNode, 0, 64);
	
	char const * const device_template = "/sys/class/graphics/fb%u/lcdcid";
	FILE *fd = NULL;
	int i = 0, id = 0;
	char name[64];
	
	do
	{
		ALOGD("i is %d", i);
		memset(name, 0, 64);
		snprintf(name, 64, device_template, i);
		fd = fopen(name, "r");
		if(fd != NULL) {
			memset(name, 0, 64);
			fgets(name, 64, fd);
			fclose(fd);
			id = atoi(name);
			if(id == 0 && strlen(MainDisplaySysNode) == 0) {
				snprintf(MainDisplaySysNode, 64, "/sys/class/graphics/fb%u/scale", i);
			}
			else if(id == 1 && strlen(AuxDisplaySysNode) == 0) {
				snprintf(AuxDisplaySysNode, 64, "/sys/class/graphics/fb%u/scale", i);
			}
		}
		i++;
	} while (fd != NULL);
	
	if(strlen(MainDisplaySysNode) == 0)
		strcpy(MainDisplaySysNode, MAIN_DISPLAY_SCALE_FILE);
	if(strlen(AuxDisplaySysNode) == 0)
		strcpy(AuxDisplaySysNode, AUX_DISPLAY_SCALE_FILE);
	ALOGD("MainDisplaySysNode is %s", MainDisplaySysNode);
	ALOGD("AuxDisplaySysNode is %s", AuxDisplaySysNode);
}

int ScreenScaleManager::SSMReadCfg() {
	return 0;
}

void ScreenScaleManager::SSMCtrlX(int display, int scalevalue) {
	int fd = -1;
	char property[PROPERTY_VALUE_MAX];
	
	ALOGD("[%s] display %d, rate %d\n", __FUNCTION__, display, scalevalue);
	fd = open(MainDisplaySysNode, O_RDWR, 0);
	if(fd < 0) return;
	memset(property, 0, PROPERTY_VALUE_MAX);
	sprintf(property, "xscale=%d", scalevalue);
	write(fd, property, strlen(property));
	close(fd);	
	
	fd = open(AuxDisplaySysNode, O_RDWR, 0);
	if(fd >= 0) {
		memset(property, 0, PROPERTY_VALUE_MAX);
		sprintf(property, "xscale=%d", scalevalue);
		write(fd, property, strlen(property));
		close(fd);	
	}
	
	memset(property, 0, PROPERTY_VALUE_MAX);
	sprintf(property, "%d", scalevalue);
	property_set(PROPETY_SCALE_X, property);
	system("sync");
	ALOGD("sync property scale_x\n");

	
	}
void ScreenScaleManager::SSMCtrlY(int display, int scalevalue) {
	int fd = -1;
	char property[PROPERTY_VALUE_MAX];
	
	ALOGD("[%s] display %d rate %d\n", __FUNCTION__, display, scalevalue);
	fd = open(MainDisplaySysNode, O_RDWR, 0);
	if(fd < 0) return;	
	memset(property, 0, PROPERTY_VALUE_MAX);
	sprintf(property, "yscale=%d", scalevalue);
	write(fd, property, strlen(property));
	close(fd);
	
	fd = open(AuxDisplaySysNode, O_RDWR, 0);
	if(fd >= 0) {
		memset(property, 0, PROPERTY_VALUE_MAX);
		sprintf(property, "yscale=%d", scalevalue);
		write(fd, property, strlen(property));
		close(fd);	
	}
	
	memset(property, 0, PROPERTY_VALUE_MAX);
	sprintf(property, "%d", scalevalue);
	property_set(PROPETY_SCALE_Y, property);
	system("sync");
	ALOGD("sync property scale_y\n");
}