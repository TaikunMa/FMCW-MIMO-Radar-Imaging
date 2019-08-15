/* Include files */

#include <stddef.h>
#include "blas.h"
#include "RadarSystemLevel_3_sfun.h"
#include "c3_RadarSystemLevel_3.h"
#include "mwmathutil.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "RadarSystemLevel_3_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c3_debug_family_names[7] = { "nargin", "nargout", "u",
  "Distance", "RCS", "lambda", "y" };

/* Function Declarations */
static void initialize_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance);
static void initialize_params_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance);
static void enable_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance);
static void disable_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct *
  chartInstance);
static void c3_update_debugger_state_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance);
static const mxArray *get_sim_state_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance);
static void set_sim_state_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance, const mxArray *c3_st);
static void finalize_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance);
static void sf_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance);
static void initSimStructsc3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance);
static void registerMessagesc3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c3_machineNumber, uint32_T
  c3_chartNumber);
static const mxArray *c3_sf_marshallOut(void *chartInstanceVoid, void *c3_inData);
static creal_T c3_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_y, const char_T *c3_identifier);
static creal_T c3_b_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void c3_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData);
static const mxArray *c3_b_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData);
static real_T c3_c_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void c3_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData);
static void c3_info_helper(c3_ResolvedFunctionInfo c3_info[18]);
static void c3_eml_scalar_eg(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance);
static void c3_eml_error(SFc3_RadarSystemLevel_3InstanceStruct *chartInstance);
static const mxArray *c3_c_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData);
static int32_T c3_d_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void c3_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData);
static uint8_T c3_e_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_b_is_active_c3_RadarSystemLevel_3, const
  char_T *c3_identifier);
static uint8_T c3_f_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void init_dsm_address_info(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance)
{
  chartInstance->c3_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c3_is_active_c3_RadarSystemLevel_3 = 0U;
}

static void initialize_params_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance)
{
  real_T c3_d0;
  real_T c3_d1;
  sf_set_error_prefix_string(
    "Error evaluating data 'RCS' in the parent workspace.\n");
  sf_mex_import_named("RCS", sf_mex_get_sfun_param(chartInstance->S, 0, 0),
                      &c3_d0, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c3_RCS = c3_d0;
  sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
  sf_set_error_prefix_string(
    "Error evaluating data 'lambda' in the parent workspace.\n");
  sf_mex_import_named("lambda", sf_mex_get_sfun_param(chartInstance->S, 1, 0),
                      &c3_d1, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c3_lambda = c3_d1;
  sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
}

static void enable_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct *
  chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c3_update_debugger_state_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance)
{
  const mxArray *c3_st;
  const mxArray *c3_y = NULL;
  creal_T c3_u;
  const mxArray *c3_b_y = NULL;
  uint8_T c3_hoistedGlobal;
  uint8_T c3_b_u;
  const mxArray *c3_c_y = NULL;
  creal_T *c3_d_y;
  c3_d_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c3_st = NULL;
  c3_st = NULL;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_createcellarray(2), FALSE);
  c3_u.re = c3_d_y->re;
  c3_u.im = c3_d_y->im;
  c3_b_y = NULL;
  sf_mex_assign(&c3_b_y, sf_mex_create("y", &c3_u, 0, 1U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 0, c3_b_y);
  c3_hoistedGlobal = chartInstance->c3_is_active_c3_RadarSystemLevel_3;
  c3_b_u = c3_hoistedGlobal;
  c3_c_y = NULL;
  sf_mex_assign(&c3_c_y, sf_mex_create("y", &c3_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 1, c3_c_y);
  sf_mex_assign(&c3_st, c3_y, FALSE);
  return c3_st;
}

static void set_sim_state_c3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance, const mxArray *c3_st)
{
  const mxArray *c3_u;
  creal_T *c3_y;
  c3_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c3_doneDoubleBufferReInit = TRUE;
  c3_u = sf_mex_dup(c3_st);
  *c3_y = c3_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c3_u, 0)),
    "y");
  chartInstance->c3_is_active_c3_RadarSystemLevel_3 = c3_e_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c3_u, 1)),
     "is_active_c3_RadarSystemLevel_3");
  sf_mex_destroy(&c3_u);
  c3_update_debugger_state_c3_RadarSystemLevel_3(chartInstance);
  sf_mex_destroy(&c3_st);
}

static void finalize_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance)
{
}

static void sf_c3_RadarSystemLevel_3(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance)
{
  real_T c3_hoistedGlobal;
  real_T c3_b_hoistedGlobal;
  real_T c3_c_hoistedGlobal;
  creal_T c3_u;
  real_T c3_Distance;
  real_T c3_b_RCS;
  real_T c3_b_lambda;
  uint32_T c3_debug_family_var_map[7];
  real_T c3_nargin = 4.0;
  real_T c3_nargout = 1.0;
  creal_T c3_y;
  real_T c3_a;
  real_T c3_b_a;
  real_T c3_ak;
  real_T c3_c_a;
  real_T c3_ar;
  real_T c3_b_y;
  real_T c3_c_y;
  real_T c3_d_y;
  real_T c3_z;
  real_T c3_x;
  real_T c3_b_x;
  real_T c3_d_a;
  real_T c3_e_a;
  real_T c3_f_a;
  real_T c3_b_ak;
  real_T c3_g_a;
  real_T c3_h_a;
  real_T c3_b;
  real_T c3_c;
  real_T c3_i_a;
  real_T c3_b_b;
  real_T c3_e_y;
  real_T c3_A;
  real_T c3_c_x;
  real_T c3_d_x;
  real_T c3_f_y;
  real_T c3_e_x;
  real_T c3_f_x;
  creal_T c3_b_u;
  real_T *c3_b_Distance;
  creal_T *c3_c_u;
  creal_T *c3_g_y;
  c3_b_Distance = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c3_g_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c3_c_u = (creal_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c3_b_Distance, 2U);
  _SFD_DATA_RANGE_CHECK(chartInstance->c3_RCS, 3U);
  _SFD_DATA_RANGE_CHECK(chartInstance->c3_lambda, 4U);
  chartInstance->c3_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  c3_hoistedGlobal = *c3_b_Distance;
  c3_b_hoistedGlobal = chartInstance->c3_RCS;
  c3_c_hoistedGlobal = chartInstance->c3_lambda;
  c3_u.re = c3_c_u->re;
  c3_u.im = c3_c_u->im;
  c3_Distance = c3_hoistedGlobal;
  c3_b_RCS = c3_b_hoistedGlobal;
  c3_b_lambda = c3_c_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 7U, 7U, c3_debug_family_names,
    c3_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_nargin, 0U, c3_b_sf_marshallOut,
    c3_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_nargout, 1U, c3_b_sf_marshallOut,
    c3_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_u, 2U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_Distance, 3U, c3_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_b_RCS, 4U, c3_b_sf_marshallOut,
    c3_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_b_lambda, 5U, c3_b_sf_marshallOut,
    c3_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_y, 6U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 4);
  c3_a = c3_Distance;
  c3_b_a = c3_a;
  c3_eml_scalar_eg(chartInstance);
  c3_ak = c3_b_a;
  c3_c_a = c3_ak;
  c3_eml_scalar_eg(chartInstance);
  c3_ar = c3_c_a;
  c3_b_y = muDoubleScalarPower(c3_ar, 4.0);
  c3_c_y = c3_b_y;
  c3_d_y = c3_c_y;
  c3_z = 1.0 / c3_d_y;
  c3_x = c3_z;
  c3_b_x = c3_x;
  if (c3_b_x < 0.0) {
    c3_eml_error(chartInstance);
  }

  c3_b_x = muDoubleScalarSqrt(c3_b_x);
  c3_d_a = c3_b_lambda;
  c3_e_a = c3_d_a;
  c3_f_a = c3_e_a;
  c3_eml_scalar_eg(chartInstance);
  c3_b_ak = c3_f_a;
  c3_g_a = c3_b_ak;
  c3_eml_scalar_eg(chartInstance);
  c3_h_a = c3_g_a;
  c3_b = c3_g_a;
  c3_c = c3_h_a * c3_b;
  c3_i_a = c3_c;
  c3_b_b = c3_b_RCS;
  c3_e_y = c3_i_a * c3_b_b;
  c3_A = c3_e_y;
  c3_c_x = c3_A;
  c3_d_x = c3_c_x;
  c3_f_y = c3_d_x / 1984.4017075391882;
  c3_e_x = c3_f_y;
  c3_f_x = c3_e_x;
  if (c3_f_x < 0.0) {
    c3_eml_error(chartInstance);
  }

  c3_f_x = muDoubleScalarSqrt(c3_f_x);
  c3_b_u.re = c3_b_x * c3_u.re;
  c3_b_u.im = c3_b_x * c3_u.im;
  c3_y.re = c3_f_x * c3_b_u.re;
  c3_y.im = c3_f_x * c3_b_u.im;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, -4);
  _SFD_SYMBOL_SCOPE_POP();
  c3_g_y->re = c3_y.re;
  c3_g_y->im = c3_y.im;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_RadarSystemLevel_3MachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance)
{
}

static void registerMessagesc3_RadarSystemLevel_3
  (SFc3_RadarSystemLevel_3InstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c3_machineNumber, uint32_T
  c3_chartNumber)
{
}

static const mxArray *c3_sf_marshallOut(void *chartInstanceVoid, void *c3_inData)
{
  const mxArray *c3_mxArrayOutData = NULL;
  creal_T c3_u;
  const mxArray *c3_y = NULL;
  SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
  chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *)chartInstanceVoid;
  c3_mxArrayOutData = NULL;
  c3_u = *(creal_T *)c3_inData;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", &c3_u, 0, 1U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c3_mxArrayOutData, c3_y, FALSE);
  return c3_mxArrayOutData;
}

static creal_T c3_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_y, const char_T *c3_identifier)
{
  creal_T c3_b_y;
  emlrtMsgIdentifier c3_thisId;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_b_y = c3_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_y), &c3_thisId);
  sf_mex_destroy(&c3_y);
  return c3_b_y;
}

static creal_T c3_b_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  creal_T c3_y;
  creal_T c3_dc0;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_dc0, 1, 0, 1U, 0, 0U, 0);
  c3_y = c3_dc0;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void c3_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData)
{
  const mxArray *c3_y;
  const char_T *c3_identifier;
  emlrtMsgIdentifier c3_thisId;
  creal_T c3_b_y;
  SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
  chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *)chartInstanceVoid;
  c3_y = sf_mex_dup(c3_mxArrayInData);
  c3_identifier = c3_varName;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_b_y = c3_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_y), &c3_thisId);
  sf_mex_destroy(&c3_y);
  *(creal_T *)c3_outData = c3_b_y;
  sf_mex_destroy(&c3_mxArrayInData);
}

static const mxArray *c3_b_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData)
{
  const mxArray *c3_mxArrayOutData = NULL;
  real_T c3_u;
  const mxArray *c3_y = NULL;
  SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
  chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *)chartInstanceVoid;
  c3_mxArrayOutData = NULL;
  c3_u = *(real_T *)c3_inData;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", &c3_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c3_mxArrayOutData, c3_y, FALSE);
  return c3_mxArrayOutData;
}

static real_T c3_c_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  real_T c3_y;
  real_T c3_d2;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_d2, 1, 0, 0U, 0, 0U, 0);
  c3_y = c3_d2;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void c3_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData)
{
  const mxArray *c3_b_lambda;
  const char_T *c3_identifier;
  emlrtMsgIdentifier c3_thisId;
  real_T c3_y;
  SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
  chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *)chartInstanceVoid;
  c3_b_lambda = sf_mex_dup(c3_mxArrayInData);
  c3_identifier = c3_varName;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_b_lambda),
    &c3_thisId);
  sf_mex_destroy(&c3_b_lambda);
  *(real_T *)c3_outData = c3_y;
  sf_mex_destroy(&c3_mxArrayInData);
}

const mxArray *sf_c3_RadarSystemLevel_3_get_eml_resolved_functions_info(void)
{
  const mxArray *c3_nameCaptureInfo;
  c3_ResolvedFunctionInfo c3_info[18];
  const mxArray *c3_m0 = NULL;
  int32_T c3_i0;
  c3_ResolvedFunctionInfo *c3_r0;
  c3_nameCaptureInfo = NULL;
  c3_nameCaptureInfo = NULL;
  c3_info_helper(c3_info);
  sf_mex_assign(&c3_m0, sf_mex_createstruct("nameCaptureInfo", 1, 18), FALSE);
  for (c3_i0 = 0; c3_i0 < 18; c3_i0++) {
    c3_r0 = &c3_info[c3_i0];
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c3_r0->context)), "context", "nameCaptureInfo",
                    c3_i0);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c3_r0->name)), "name", "nameCaptureInfo", c3_i0);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c3_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c3_i0);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c3_r0->resolved)), "resolved", "nameCaptureInfo",
                    c3_i0);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c3_i0);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c3_i0);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c3_i0);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c3_i0);
  }

  sf_mex_assign(&c3_nameCaptureInfo, c3_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c3_nameCaptureInfo);
  return c3_nameCaptureInfo;
}

static void c3_info_helper(c3_ResolvedFunctionInfo c3_info[18])
{
  c3_info[0].context = "";
  c3_info[0].name = "power";
  c3_info[0].dominantType = "double";
  c3_info[0].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c3_info[0].fileTimeLo = 1348217130U;
  c3_info[0].fileTimeHi = 0U;
  c3_info[0].mFileTimeLo = 0U;
  c3_info[0].mFileTimeHi = 0U;
  c3_info[1].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c3_info[1].name = "eml_scalar_eg";
  c3_info[1].dominantType = "double";
  c3_info[1].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c3_info[1].fileTimeLo = 1286843996U;
  c3_info[1].fileTimeHi = 0U;
  c3_info[1].mFileTimeLo = 0U;
  c3_info[1].mFileTimeHi = 0U;
  c3_info[2].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c3_info[2].name = "eml_scalexp_alloc";
  c3_info[2].dominantType = "double";
  c3_info[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c3_info[2].fileTimeLo = 1352450060U;
  c3_info[2].fileTimeHi = 0U;
  c3_info[2].mFileTimeLo = 0U;
  c3_info[2].mFileTimeHi = 0U;
  c3_info[3].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c3_info[3].name = "floor";
  c3_info[3].dominantType = "double";
  c3_info[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c3_info[3].fileTimeLo = 1343855580U;
  c3_info[3].fileTimeHi = 0U;
  c3_info[3].mFileTimeLo = 0U;
  c3_info[3].mFileTimeHi = 0U;
  c3_info[4].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c3_info[4].name = "eml_scalar_floor";
  c3_info[4].dominantType = "double";
  c3_info[4].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
  c3_info[4].fileTimeLo = 1286843926U;
  c3_info[4].fileTimeHi = 0U;
  c3_info[4].mFileTimeLo = 0U;
  c3_info[4].mFileTimeHi = 0U;
  c3_info[5].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!scalar_float_power";
  c3_info[5].name = "eml_scalar_eg";
  c3_info[5].dominantType = "double";
  c3_info[5].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c3_info[5].fileTimeLo = 1286843996U;
  c3_info[5].fileTimeHi = 0U;
  c3_info[5].mFileTimeLo = 0U;
  c3_info[5].mFileTimeHi = 0U;
  c3_info[6].context = "";
  c3_info[6].name = "rdivide";
  c3_info[6].dominantType = "double";
  c3_info[6].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c3_info[6].fileTimeLo = 1346535588U;
  c3_info[6].fileTimeHi = 0U;
  c3_info[6].mFileTimeLo = 0U;
  c3_info[6].mFileTimeHi = 0U;
  c3_info[7].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c3_info[7].name = "eml_scalexp_compatible";
  c3_info[7].dominantType = "double";
  c3_info[7].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m";
  c3_info[7].fileTimeLo = 1286843996U;
  c3_info[7].fileTimeHi = 0U;
  c3_info[7].mFileTimeLo = 0U;
  c3_info[7].mFileTimeHi = 0U;
  c3_info[8].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c3_info[8].name = "eml_div";
  c3_info[8].dominantType = "double";
  c3_info[8].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  c3_info[8].fileTimeLo = 1313373010U;
  c3_info[8].fileTimeHi = 0U;
  c3_info[8].mFileTimeLo = 0U;
  c3_info[8].mFileTimeHi = 0U;
  c3_info[9].context = "";
  c3_info[9].name = "sqrt";
  c3_info[9].dominantType = "double";
  c3_info[9].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c3_info[9].fileTimeLo = 1343855586U;
  c3_info[9].fileTimeHi = 0U;
  c3_info[9].mFileTimeLo = 0U;
  c3_info[9].mFileTimeHi = 0U;
  c3_info[10].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c3_info[10].name = "eml_error";
  c3_info[10].dominantType = "char";
  c3_info[10].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_error.m";
  c3_info[10].fileTimeLo = 1343855558U;
  c3_info[10].fileTimeHi = 0U;
  c3_info[10].mFileTimeLo = 0U;
  c3_info[10].mFileTimeHi = 0U;
  c3_info[11].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c3_info[11].name = "eml_scalar_sqrt";
  c3_info[11].dominantType = "double";
  c3_info[11].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_sqrt.m";
  c3_info[11].fileTimeLo = 1286843938U;
  c3_info[11].fileTimeHi = 0U;
  c3_info[11].mFileTimeLo = 0U;
  c3_info[11].mFileTimeHi = 0U;
  c3_info[12].context = "";
  c3_info[12].name = "mpower";
  c3_info[12].dominantType = "double";
  c3_info[12].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c3_info[12].fileTimeLo = 1286844042U;
  c3_info[12].fileTimeHi = 0U;
  c3_info[12].mFileTimeLo = 0U;
  c3_info[12].mFileTimeHi = 0U;
  c3_info[13].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c3_info[13].name = "power";
  c3_info[13].dominantType = "double";
  c3_info[13].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c3_info[13].fileTimeLo = 1348217130U;
  c3_info[13].fileTimeHi = 0U;
  c3_info[13].mFileTimeLo = 0U;
  c3_info[13].mFileTimeHi = 0U;
  c3_info[14].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!scalar_float_power";
  c3_info[14].name = "mtimes";
  c3_info[14].dominantType = "double";
  c3_info[14].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c3_info[14].fileTimeLo = 1289544892U;
  c3_info[14].fileTimeHi = 0U;
  c3_info[14].mFileTimeLo = 0U;
  c3_info[14].mFileTimeHi = 0U;
  c3_info[15].context = "";
  c3_info[15].name = "mtimes";
  c3_info[15].dominantType = "double";
  c3_info[15].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c3_info[15].fileTimeLo = 1289544892U;
  c3_info[15].fileTimeHi = 0U;
  c3_info[15].mFileTimeLo = 0U;
  c3_info[15].mFileTimeHi = 0U;
  c3_info[16].context = "";
  c3_info[16].name = "mrdivide";
  c3_info[16].dominantType = "double";
  c3_info[16].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c3_info[16].fileTimeLo = 1357976748U;
  c3_info[16].fileTimeHi = 0U;
  c3_info[16].mFileTimeLo = 1319755166U;
  c3_info[16].mFileTimeHi = 0U;
  c3_info[17].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c3_info[17].name = "rdivide";
  c3_info[17].dominantType = "double";
  c3_info[17].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c3_info[17].fileTimeLo = 1346535588U;
  c3_info[17].fileTimeHi = 0U;
  c3_info[17].mFileTimeLo = 0U;
  c3_info[17].mFileTimeHi = 0U;
}

static void c3_eml_scalar_eg(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance)
{
}

static void c3_eml_error(SFc3_RadarSystemLevel_3InstanceStruct *chartInstance)
{
  int32_T c3_i1;
  static char_T c3_cv0[30] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o', 'l',
    'b', 'o', 'x', ':', 'E', 'l', 'F', 'u', 'n', 'D', 'o', 'm', 'a', 'i', 'n',
    'E', 'r', 'r', 'o', 'r' };

  char_T c3_u[30];
  const mxArray *c3_y = NULL;
  int32_T c3_i2;
  static char_T c3_cv1[4] = { 's', 'q', 'r', 't' };

  char_T c3_b_u[4];
  const mxArray *c3_b_y = NULL;
  for (c3_i1 = 0; c3_i1 < 30; c3_i1++) {
    c3_u[c3_i1] = c3_cv0[c3_i1];
  }

  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", c3_u, 10, 0U, 1U, 0U, 2, 1, 30), FALSE);
  for (c3_i2 = 0; c3_i2 < 4; c3_i2++) {
    c3_b_u[c3_i2] = c3_cv1[c3_i2];
  }

  c3_b_y = NULL;
  sf_mex_assign(&c3_b_y, sf_mex_create("y", c3_b_u, 10, 0U, 1U, 0U, 2, 1, 4),
                FALSE);
  sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 2U, 14,
    c3_y, 14, c3_b_y));
}

static const mxArray *c3_c_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData)
{
  const mxArray *c3_mxArrayOutData = NULL;
  int32_T c3_u;
  const mxArray *c3_y = NULL;
  SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
  chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *)chartInstanceVoid;
  c3_mxArrayOutData = NULL;
  c3_u = *(int32_T *)c3_inData;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", &c3_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c3_mxArrayOutData, c3_y, FALSE);
  return c3_mxArrayOutData;
}

static int32_T c3_d_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  int32_T c3_y;
  int32_T c3_i3;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_i3, 1, 6, 0U, 0, 0U, 0);
  c3_y = c3_i3;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void c3_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData)
{
  const mxArray *c3_b_sfEvent;
  const char_T *c3_identifier;
  emlrtMsgIdentifier c3_thisId;
  int32_T c3_y;
  SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
  chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *)chartInstanceVoid;
  c3_b_sfEvent = sf_mex_dup(c3_mxArrayInData);
  c3_identifier = c3_varName;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_b_sfEvent),
    &c3_thisId);
  sf_mex_destroy(&c3_b_sfEvent);
  *(int32_T *)c3_outData = c3_y;
  sf_mex_destroy(&c3_mxArrayInData);
}

static uint8_T c3_e_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_b_is_active_c3_RadarSystemLevel_3, const
  char_T *c3_identifier)
{
  uint8_T c3_y;
  emlrtMsgIdentifier c3_thisId;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_f_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c3_b_is_active_c3_RadarSystemLevel_3), &c3_thisId);
  sf_mex_destroy(&c3_b_is_active_c3_RadarSystemLevel_3);
  return c3_y;
}

static uint8_T c3_f_emlrt_marshallIn(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance, const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  uint8_T c3_y;
  uint8_T c3_u0;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_u0, 1, 3, 0U, 0, 0U, 0);
  c3_y = c3_u0;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void init_dsm_address_info(SFc3_RadarSystemLevel_3InstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
#ifdef utFree
#undef utFree
#endif

#ifdef utMalloc
#undef utMalloc
#endif

#ifdef __cplusplus

extern "C" void *utMalloc(size_t size);
extern "C" void utFree(void*);

#else

extern void *utMalloc(size_t size);
extern void utFree(void*);

#endif

void sf_c3_RadarSystemLevel_3_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1115212738U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(362765503U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1705282076U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2483421183U);
}

mxArray *sf_c3_RadarSystemLevel_3_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("xtCYd73lUTB5BBVIFJTzjC");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(1));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(1));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c3_RadarSystemLevel_3_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c3_RadarSystemLevel_3(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"y\",},{M[8],M[0],T\"is_active_c3_RadarSystemLevel_3\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c3_RadarSystemLevel_3_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
    chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _RadarSystemLevel_3MachineNumber_,
           3,
           1,
           1,
           5,
           0,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_RadarSystemLevel_3MachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (sfGlobalDebugInstanceStruct,_RadarSystemLevel_3MachineNumber_,
             chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(sfGlobalDebugInstanceStruct,
            _RadarSystemLevel_3MachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"u");
          _SFD_SET_DATA_PROPS(1,2,0,1,"y");
          _SFD_SET_DATA_PROPS(2,1,1,0,"Distance");
          _SFD_SET_DATA_PROPS(3,10,0,0,"RCS");
          _SFD_SET_DATA_PROPS(4,10,0,0,"lambda");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,1,0,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,122);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,1,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,1,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_b_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_b_sf_marshallOut,(MexInFcnForType)c3_b_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_b_sf_marshallOut,(MexInFcnForType)c3_b_sf_marshallIn);

        {
          creal_T *c3_u;
          creal_T *c3_y;
          real_T *c3_Distance;
          c3_Distance = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c3_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c3_u = (creal_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c3_u);
          _SFD_SET_DATA_VALUE_PTR(1U, c3_y);
          _SFD_SET_DATA_VALUE_PTR(2U, c3_Distance);
          _SFD_SET_DATA_VALUE_PTR(3U, &chartInstance->c3_RCS);
          _SFD_SET_DATA_VALUE_PTR(4U, &chartInstance->c3_lambda);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(sfGlobalDebugInstanceStruct,
        _RadarSystemLevel_3MachineNumber_,chartInstance->chartNumber,
        chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization(void)
{
  return "ZyLjUOOBtoM7TsZJtTsVL";
}

static void sf_opaque_initialize_c3_RadarSystemLevel_3(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInstanceVar);
  initialize_c3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c3_RadarSystemLevel_3(void *chartInstanceVar)
{
  enable_c3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c3_RadarSystemLevel_3(void *chartInstanceVar)
{
  disable_c3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c3_RadarSystemLevel_3(void *chartInstanceVar)
{
  sf_c3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c3_RadarSystemLevel_3(SimStruct*
  S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c3_RadarSystemLevel_3
    ((SFc3_RadarSystemLevel_3InstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c3_RadarSystemLevel_3();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c3_RadarSystemLevel_3(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c3_RadarSystemLevel_3();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c3_RadarSystemLevel_3(SimStruct* S)
{
  return sf_internal_get_sim_state_c3_RadarSystemLevel_3(S);
}

static void sf_opaque_set_sim_state_c3_RadarSystemLevel_3(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c3_RadarSystemLevel_3(S, st);
}

static void sf_opaque_terminate_c3_RadarSystemLevel_3(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc3_RadarSystemLevel_3InstanceStruct*) chartInstanceVar)
      ->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_RadarSystemLevel_3_optimization_info();
    }

    finalize_c3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
      chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc3_RadarSystemLevel_3((SFc3_RadarSystemLevel_3InstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c3_RadarSystemLevel_3(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c3_RadarSystemLevel_3
      ((SFc3_RadarSystemLevel_3InstanceStruct*)(((ChartInfoStruct *)
         ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c3_RadarSystemLevel_3(SimStruct *S)
{
  /* Actual parameters from chart:
     RCS lambda
   */
  const char_T *rtParamNames[] = { "RCS", "lambda" };

  ssSetNumRunTimeParams(S,ssGetSFcnParamsCount(S));

  /* registration for RCS*/
  ssRegDlgParamAsRunTimeParam(S, 0, 0, rtParamNames[0], SS_DOUBLE);

  /* registration for lambda*/
  ssRegDlgParamAsRunTimeParam(S, 1, 1, rtParamNames[1], SS_DOUBLE);
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_RadarSystemLevel_3_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      3);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,3,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,3,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,3);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,3,2);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,3,1);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=1; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 2; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,3);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(3393826002U));
  ssSetChecksum1(S,(1693001531U));
  ssSetChecksum2(S,(1648500138U));
  ssSetChecksum3(S,(3722519696U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c3_RadarSystemLevel_3(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c3_RadarSystemLevel_3(SimStruct *S)
{
  SFc3_RadarSystemLevel_3InstanceStruct *chartInstance;
  chartInstance = (SFc3_RadarSystemLevel_3InstanceStruct *)utMalloc(sizeof
    (SFc3_RadarSystemLevel_3InstanceStruct));
  memset(chartInstance, 0, sizeof(SFc3_RadarSystemLevel_3InstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.disableChart =
    sf_opaque_disable_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.mdlStart = mdlStart_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c3_RadarSystemLevel_3;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c3_RadarSystemLevel_3_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c3_RadarSystemLevel_3(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c3_RadarSystemLevel_3(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c3_RadarSystemLevel_3(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c3_RadarSystemLevel_3_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
