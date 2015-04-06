JNIPATH := $(call my-dir)
LOCAL_PATH := $(JNIPATH)

# Build Tesseract and Leptonica
#TESSERACT_PATH := $(LOCAL_PATH)/com_googlecode_tesseract_android/src
#LEPTONICA_PATH := $(LOCAL_PATH)/com_googlecode_leptonica_android/src
#include $(call all-subdir-makefiles)

# Bulding OpenCV
include $(CLEAR_VARS)
LOCAL_PATH := $(JNIPATH)
OPENCV_LIB_TYPE:=STATIC
OPENCV_INSTALL_MODULES:=on

include $(LOCAL_PATH)/../../../plugins/com.github.pauloubuntu.cordova-plugin-tesseract-camera/src/android/libs/OpenCV-2.4.10-android-sdk/sdk/native/jni/OpenCV.mk

LOCAL_MODULE    := ImageProcessing
LOCAL_SRC_FILES := ImageProcessing.cpp
LOCAL_LDLIBS +=  -llog -ldl

include $(BUILD_SHARED_LIBRARY)