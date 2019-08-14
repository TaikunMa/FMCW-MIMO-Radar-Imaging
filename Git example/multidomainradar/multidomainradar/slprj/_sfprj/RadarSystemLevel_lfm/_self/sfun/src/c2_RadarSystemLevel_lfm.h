#ifndef __c2_RadarSystemLevel_lfm_h__
#define __c2_RadarSystemLevel_lfm_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_c2_ResolvedFunctionInfo
#define typedef_c2_ResolvedFunctionInfo

typedef struct {
  const char * context;
  const char * name;
  const char * dominantType;
  const char * resolved;
  uint32_T fileTimeLo;
  uint32_T fileTimeHi;
  uint32_T mFileTimeLo;
  uint32_T mFileTimeHi;
} c2_ResolvedFunctionInfo;

#endif                                 /*typedef_c2_ResolvedFunctionInfo*/

#ifndef struct_stcC0k9ABg5dYeGD7YNw1k
#define struct_stcC0k9ABg5dYeGD7YNw1k

struct stcC0k9ABg5dYeGD7YNw1k
{
  boolean_T isInitialized;
  boolean_T isReleased;
  boolean_T TunablePropsChanged;
  real_T pOutputStartSampleIndex;
  real_T pOutputSampleInterval[2];
};

#endif                                 /*struct_stcC0k9ABg5dYeGD7YNw1k*/

#ifndef typedef_c2_phased_LinearFMWaveform
#define typedef_c2_phased_LinearFMWaveform

typedef struct stcC0k9ABg5dYeGD7YNw1k c2_phased_LinearFMWaveform;

#endif                                 /*typedef_c2_phased_LinearFMWaveform*/

#ifndef typedef_SFc2_RadarSystemLevel_lfmInstanceStruct
#define typedef_SFc2_RadarSystemLevel_lfmInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c2_sfEvent;
  boolean_T c2_isStable;
  boolean_T c2_doneDoubleBufferReInit;
  uint8_T c2_is_active_c2_RadarSystemLevel_lfm;
  c2_phased_LinearFMWaveform c2_hwav;
  boolean_T c2_hwav_not_empty;
} SFc2_RadarSystemLevel_lfmInstanceStruct;

#endif                                 /*typedef_SFc2_RadarSystemLevel_lfmInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c2_RadarSystemLevel_lfm_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c2_RadarSystemLevel_lfm_get_check_sum(mxArray *plhs[]);
extern void c2_RadarSystemLevel_lfm_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
