/* Include files */

#include "blascompat32.h"
#include "RadarSystemLevel_lfm_sfun.h"
#include "c2_RadarSystemLevel_lfm.h"
#include "mwmathutil.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "RadarSystemLevel_lfm_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c2_debug_family_names[3] = { "nargin", "nargout", "y" };

static const char * c2_b_debug_family_names[4] = { "nargin", "nargout", "x",
  "hwav" };

/* Function Declarations */
static void initialize_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void initialize_params_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void enable_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void disable_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void c2_update_debugger_state_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void set_sim_state_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance, const mxArray *c2_st);
static void finalize_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void sf_c2_RadarSystemLevel_lfm(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance);
static void c2_chartstep_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void initSimStructsc2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber);
static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, void *c2_inData);
static creal_T c2_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_y, const char_T *c2_identifier);
static creal_T c2_b_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static real_T c2_c_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static const mxArray *c2_c_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static void c2_info_helper(c2_ResolvedFunctionInfo c2_info[143]);
static void c2_b_info_helper(c2_ResolvedFunctionInfo c2_info[143]);
static void c2_c_info_helper(c2_ResolvedFunctionInfo c2_info[143]);
static void c2_cell_cell(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void c2_iscellstr(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void c2_isconstcell(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance);
static void c2_SystemProp_matlabCodegenSetAnyProp
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj);
static void c2_b_SystemProp_matlabCodegenSetAnyProp
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj);
static void c2_c_SystemProp_matlabCodegenSetAnyProp
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj);
static void c2_pvParse(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
  c2_phased_LinearFMWaveform *c2_obj);
static creal_T c2_SystemCore_step(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, c2_phased_LinearFMWaveform *c2_obj);
static void c2_AbstractContinuousPhasePulseWaveform_validatePropertiesImpl
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj);
static boolean_T c2_any(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
  boolean_T c2_x);
static void c2_AbstractPulseWaveform_setupImpl
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj);
static void c2_narginchk(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void c2_b_iscellstr(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance);
static void c2_b_isconstcell(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance);
static void c2_val2ind(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static void c2_validateattributes(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance);
static void c2_b_validateattributes(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance);
static void c2_realmax(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance);
static creal_T c2_AbstractPulseWaveform_stepImpl
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj);
static const mxArray *c2_d_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static int32_T c2_d_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static uint8_T c2_e_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_RadarSystemLevel_lfm, const
  char_T *c2_identifier);
static uint8_T c2_f_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void init_dsm_address_info(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
  chartInstance->c2_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c2_hwav_not_empty = FALSE;
  chartInstance->c2_is_active_c2_RadarSystemLevel_lfm = 0U;
}

static void initialize_params_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static void enable_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c2_update_debugger_state_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
  const mxArray *c2_st;
  const mxArray *c2_y = NULL;
  creal_T c2_u;
  const mxArray *c2_b_y = NULL;
  uint8_T c2_hoistedGlobal;
  uint8_T c2_b_u;
  const mxArray *c2_c_y = NULL;
  creal_T *c2_d_y;
  c2_d_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c2_st = NULL;
  c2_st = NULL;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_createcellarray(2), FALSE);
  c2_u.re = c2_d_y->re;
  c2_u.im = c2_d_y->im;
  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", &c2_u, 0, 1U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 0, c2_b_y);
  c2_hoistedGlobal = chartInstance->c2_is_active_c2_RadarSystemLevel_lfm;
  c2_b_u = c2_hoistedGlobal;
  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 1, c2_c_y);
  sf_mex_assign(&c2_st, c2_y, FALSE);
  return c2_st;
}

static void set_sim_state_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance, const mxArray *c2_st)
{
  const mxArray *c2_u;
  creal_T *c2_y;
  c2_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c2_doneDoubleBufferReInit = TRUE;
  c2_u = sf_mex_dup(c2_st);
  *c2_y = c2_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 0)),
    "y");
  chartInstance->c2_is_active_c2_RadarSystemLevel_lfm = c2_e_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 1)),
     "is_active_c2_RadarSystemLevel_lfm");
  sf_mex_destroy(&c2_u);
  c2_update_debugger_state_c2_RadarSystemLevel_lfm(chartInstance);
  sf_mex_destroy(&c2_st);
}

static void finalize_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static void sf_c2_RadarSystemLevel_lfm(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 1U, chartInstance->c2_sfEvent);
  chartInstance->c2_sfEvent = CALL_EVENT;
  c2_chartstep_c2_RadarSystemLevel_lfm(chartInstance);
  sf_debug_check_for_state_inconsistency(_RadarSystemLevel_lfmMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void c2_chartstep_c2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
  uint32_T c2_debug_family_var_map[3];
  real_T c2_nargin = 0.0;
  real_T c2_nargout = 1.0;
  creal_T c2_y;
  uint32_T c2_b_debug_family_var_map[4];
  real_T c2_b_nargin = 0.0;
  real_T c2_b_nargout = 1.0;
  c2_phased_LinearFMWaveform *c2_obj;
  c2_phased_LinearFMWaveform *c2_b_obj;
  c2_phased_LinearFMWaveform *c2_c_obj;
  c2_phased_LinearFMWaveform *c2_d_obj;
  c2_phased_LinearFMWaveform *c2_e_obj;
  c2_phased_LinearFMWaveform *c2_f_obj;
  c2_phased_LinearFMWaveform *c2_g_obj;
  c2_phased_LinearFMWaveform *c2_h_obj;
  c2_phased_LinearFMWaveform *c2_i_obj;
  c2_phased_LinearFMWaveform *c2_j_obj;
  c2_phased_LinearFMWaveform *c2_k_obj;
  c2_phased_LinearFMWaveform *c2_l_obj;
  c2_phased_LinearFMWaveform *c2_m_obj;
  c2_phased_LinearFMWaveform *c2_n_obj;
  creal_T *c2_b_y;
  c2_b_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 1U, chartInstance->c2_sfEvent);
  sf_debug_symbol_scope_push_eml(0U, 3U, 3U, c2_debug_family_names,
    c2_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c2_nargin, 0U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c2_nargout, 1U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c2_y, 2U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 4);
  sf_debug_symbol_scope_push_eml(0U, 4U, 4U, c2_b_debug_family_names,
    c2_b_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c2_b_nargin, 0U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c2_b_nargout, 1U,
    c2_b_sf_marshallOut, c2_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c2_y, 2U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  sf_debug_symbol_scope_add_eml(&chartInstance->c2_hwav, 3U, c2_c_sf_marshallOut);
  CV_SCRIPT_FCN(0, 0);
  _SFD_SCRIPT_CALL(0U, chartInstance->c2_sfEvent, 3);
  _SFD_SCRIPT_CALL(0U, chartInstance->c2_sfEvent, 5);
  if (CV_SCRIPT_IF(0, 0, !chartInstance->c2_hwav_not_empty)) {
    _SFD_SCRIPT_CALL(0U, chartInstance->c2_sfEvent, 6);
    c2_obj = &chartInstance->c2_hwav;
    c2_b_obj = c2_obj;
    c2_c_obj = c2_b_obj;
    c2_d_obj = c2_c_obj;
    c2_e_obj = c2_d_obj;
    c2_f_obj = c2_e_obj;
    c2_g_obj = c2_f_obj;
    c2_h_obj = c2_g_obj;
    c2_i_obj = c2_h_obj;
    c2_j_obj = c2_i_obj;
    c2_k_obj = c2_j_obj;
    c2_l_obj = c2_k_obj;
    c2_l_obj->isInitialized = FALSE;
    c2_l_obj->isReleased = FALSE;
    c2_l_obj->TunablePropsChanged = FALSE;
    c2_m_obj = c2_f_obj;
    c2_n_obj = c2_m_obj;
    c2_pvParse(chartInstance, c2_n_obj);
    chartInstance->c2_hwav_not_empty = TRUE;
  }

  _SFD_SCRIPT_CALL(0U, chartInstance->c2_sfEvent, 15);
  c2_y = c2_SystemCore_step(chartInstance, &chartInstance->c2_hwav);
  _SFD_SCRIPT_CALL(0U, chartInstance->c2_sfEvent, -15);
  sf_debug_symbol_scope_pop();
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, -4);
  sf_debug_symbol_scope_pop();
  c2_b_y->re = c2_y.re;
  c2_b_y->im = c2_y.im;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c2_sfEvent);
}

static void initSimStructsc2_RadarSystemLevel_lfm
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber)
{
  _SFD_SCRIPT_TRANSLATION(c2_chartNumber, 0U, sf_debug_get_script_id(
    "C:/Work/Demos/radardemos/waveform_lfm.m"));
}

static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, void *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  creal_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(creal_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 0, 1U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static creal_T c2_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_y, const char_T *c2_identifier)
{
  creal_T c2_b_y;
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_b_y = c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_y), &c2_thisId);
  sf_mex_destroy(&c2_y);
  return c2_b_y;
}

static creal_T c2_b_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  creal_T c2_y;
  creal_T c2_dc0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_dc0, 1, 0, 1U, 0, 0U, 0);
  c2_y = c2_dc0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_y;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  creal_T c2_b_y;
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)chartInstanceVoid;
  c2_y = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_b_y = c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_y), &c2_thisId);
  sf_mex_destroy(&c2_y);
  *(creal_T *)c2_outData = c2_b_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  real_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(real_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static real_T c2_c_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  real_T c2_y;
  real_T c2_d0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_d0, 1, 0, 0U, 0, 0U, 0);
  c2_y = c2_d0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_nargout;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  real_T c2_y;
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)chartInstanceVoid;
  c2_nargout = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_nargout), &c2_thisId);
  sf_mex_destroy(&c2_nargout);
  *(real_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

static const mxArray *c2_c_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData;
  const mxArray *c2_y = NULL;
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_mxArrayOutData = NULL;
  c2_y = NULL;
  if (!chartInstance->c2_hwav_not_empty) {
    sf_mex_assign(&c2_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0), FALSE);
  } else {
    sf_mex_assign(&c2_y, sf_mex_create("y",
      "Variables of class type cannot be displayed.", 15, 0U, 0U, 0U, 2, 1,
      strlen("Variables of class type cannot be displayed.")), FALSE);
  }

  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

const mxArray *sf_c2_RadarSystemLevel_lfm_get_eml_resolved_functions_info(void)
{
  const mxArray *c2_nameCaptureInfo;
  c2_ResolvedFunctionInfo c2_info[143];
  const mxArray *c2_m0 = NULL;
  int32_T c2_i0;
  c2_ResolvedFunctionInfo *c2_r0;
  c2_nameCaptureInfo = NULL;
  c2_nameCaptureInfo = NULL;
  c2_info_helper(c2_info);
  c2_b_info_helper(c2_info);
  c2_c_info_helper(c2_info);
  sf_mex_assign(&c2_m0, sf_mex_createstruct("nameCaptureInfo", 1, 143), FALSE);
  for (c2_i0 = 0; c2_i0 < 143; c2_i0++) {
    c2_r0 = &c2_info[c2_i0];
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c2_r0->context)), "context", "nameCaptureInfo",
                    c2_i0);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c2_r0->name)), "name", "nameCaptureInfo", c2_i0);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c2_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c2_i0);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c2_r0->resolved)), "resolved", "nameCaptureInfo",
                    c2_i0);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c2_i0);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c2_i0);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c2_i0);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c2_i0);
  }

  sf_mex_assign(&c2_nameCaptureInfo, c2_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c2_nameCaptureInfo);
  return c2_nameCaptureInfo;
}

static void c2_info_helper(c2_ResolvedFunctionInfo c2_info[143])
{
  c2_info[0].context = "";
  c2_info[0].name = "waveform_lfm";
  c2_info[0].dominantType = "";
  c2_info[0].resolved = "[E]C:/Work/Demos/radardemos/waveform_lfm.m";
  c2_info[0].fileTimeLo = 1361384493U;
  c2_info[0].fileTimeHi = 0U;
  c2_info[0].mFileTimeLo = 0U;
  c2_info[0].mFileTimeHi = 0U;
  c2_info[1].context = "[E]C:/Work/Demos/radardemos/waveform_lfm.m";
  c2_info[1].name = "mrdivide";
  c2_info[1].dominantType = "double";
  c2_info[1].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[1].fileTimeLo = 1342836144U;
  c2_info[1].fileTimeHi = 0U;
  c2_info[1].mFileTimeLo = 1319755166U;
  c2_info[1].mFileTimeHi = 0U;
  c2_info[2].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[2].name = "rdivide";
  c2_info[2].dominantType = "double";
  c2_info[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c2_info[2].fileTimeLo = 1286844044U;
  c2_info[2].fileTimeHi = 0U;
  c2_info[2].mFileTimeLo = 0U;
  c2_info[2].mFileTimeHi = 0U;
  c2_info[3].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c2_info[3].name = "eml_div";
  c2_info[3].dominantType = "double";
  c2_info[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  c2_info[3].fileTimeLo = 1313373010U;
  c2_info[3].fileTimeHi = 0U;
  c2_info[3].mFileTimeLo = 0U;
  c2_info[3].mFileTimeHi = 0U;
  c2_info[4].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/System.p";
  c2_info[4].name = "matlab.system.coder.SystemProp";
  c2_info[4].dominantType = "unknown";
  c2_info[4].resolved =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[4].fileTimeLo = 1342833426U;
  c2_info[4].fileTimeHi = 0U;
  c2_info[4].mFileTimeLo = 0U;
  c2_info[4].mFileTimeHi = 0U;
  c2_info[5].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/System.p";
  c2_info[5].name = "matlab.system.coder.SystemCore";
  c2_info[5].dominantType = "unknown";
  c2_info[5].resolved =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p";
  c2_info[5].fileTimeLo = 1342833426U;
  c2_info[5].fileTimeHi = 0U;
  c2_info[5].mFileTimeLo = 0U;
  c2_info[5].mFileTimeHi = 0U;
  c2_info[6].context = "";
  c2_info[6].name = "matlab.system.coder.System";
  c2_info[6].dominantType = "unknown";
  c2_info[6].resolved =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/System.p";
  c2_info[6].fileTimeLo = 1342833426U;
  c2_info[6].fileTimeHi = 0U;
  c2_info[6].mFileTimeLo = 0U;
  c2_info[6].mFileTimeHi = 0U;
  c2_info[7].context =
    "[IXC]$matlabroot$/toolbox/matlab/system/+matlab/System.p";
  c2_info[7].name = "matlab.system.System";
  c2_info[7].dominantType = "unknown";
  c2_info[7].resolved =
    "[IXC]$matlabroot$/toolbox/matlab/system/+matlab/+system/System.p";
  c2_info[7].fileTimeLo = 1342829290U;
  c2_info[7].fileTimeHi = 0U;
  c2_info[7].mFileTimeLo = 0U;
  c2_info[7].mFileTimeHi = 0U;
  c2_info[8].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[8].name = "matlab.System";
  c2_info[8].dominantType = "unknown";
  c2_info[8].resolved =
    "[IXC]$matlabroot$/toolbox/matlab/system/+matlab/System.p";
  c2_info[8].fileTimeLo = 1342829288U;
  c2_info[8].fileTimeHi = 0U;
  c2_info[8].mFileTimeLo = 0U;
  c2_info[8].mFileTimeHi = 0U;
  c2_info[9].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[9].name = "phased.internal.AbstractPulseWaveform";
  c2_info[9].dominantType = "unknown";
  c2_info[9].resolved =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[9].fileTimeLo = 1333853632U;
  c2_info[9].fileTimeHi = 0U;
  c2_info[9].mFileTimeLo = 0U;
  c2_info[9].mFileTimeHi = 0U;
  c2_info[10].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[10].name = "phased.internal.AbstractContinuousPhasePulseWaveform";
  c2_info[10].dominantType = "unknown";
  c2_info[10].resolved =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[10].fileTimeLo = 1332459556U;
  c2_info[10].fileTimeHi = 0U;
  c2_info[10].mFileTimeLo = 0U;
  c2_info[10].mFileTimeHi = 0U;
  c2_info[11].context = "[E]C:/Work/Demos/radardemos/waveform_lfm.m";
  c2_info[11].name = "phased.LinearFMWaveform";
  c2_info[11].dominantType = "char";
  c2_info[11].resolved =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[11].fileTimeLo = 1333853618U;
  c2_info[11].fileTimeHi = 0U;
  c2_info[11].mFileTimeLo = 0U;
  c2_info[11].mFileTimeHi = 0U;
  c2_info[12].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[12].name = "matlab.system.coder.SystemProp";
  c2_info[12].dominantType = "";
  c2_info[12].resolved =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[12].fileTimeLo = 1342833426U;
  c2_info[12].fileTimeHi = 0U;
  c2_info[12].mFileTimeLo = 0U;
  c2_info[12].mFileTimeHi = 0U;
  c2_info[13].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[13].name = "matlab.system.isSystemObject";
  c2_info[13].dominantType = "char";
  c2_info[13].resolved =
    "[IXE]$matlabroot$/toolbox/matlab/system/+matlab/+system/isSystemObject.p";
  c2_info[13].fileTimeLo = 1342829290U;
  c2_info[13].fileTimeHi = 0U;
  c2_info[13].mFileTimeLo = 0U;
  c2_info[13].mFileTimeHi = 0U;
  c2_info[14].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[14].name = "length";
  c2_info[14].dominantType = "cell";
  c2_info[14].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/length.m";
  c2_info[14].fileTimeLo = 1303171406U;
  c2_info[14].fileTimeHi = 0U;
  c2_info[14].mFileTimeLo = 0U;
  c2_info[14].mFileTimeHi = 0U;
  c2_info[15].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[15].name = "matlab.system.pvParse";
  c2_info[15].dominantType = "phased.LinearFMWaveform";
  c2_info[15].resolved =
    "[IXE]$matlabroot$/toolbox/matlab/system/+matlab/+system/pvParse.p";
  c2_info[15].fileTimeLo = 1342829290U;
  c2_info[15].fileTimeHi = 0U;
  c2_info[15].mFileTimeLo = 0U;
  c2_info[15].mFileTimeHi = 0U;
  c2_info[16].context =
    "[IXE]$matlabroot$/toolbox/matlab/system/+matlab/+system/pvParse.p";
  c2_info[16].name = "length";
  c2_info[16].dominantType = "cell";
  c2_info[16].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/length.m";
  c2_info[16].fileTimeLo = 1303171406U;
  c2_info[16].fileTimeHi = 0U;
  c2_info[16].mFileTimeLo = 0U;
  c2_info[16].mFileTimeHi = 0U;
  c2_info[17].context =
    "[IXE]$matlabroot$/toolbox/matlab/system/+matlab/+system/pvParse.p";
  c2_info[17].name = "rem";
  c2_info[17].dominantType = "double";
  c2_info[17].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/rem.m";
  c2_info[17].fileTimeLo = 1326753198U;
  c2_info[17].fileTimeHi = 0U;
  c2_info[17].mFileTimeLo = 0U;
  c2_info[17].mFileTimeHi = 0U;
  c2_info[18].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/rem.m";
  c2_info[18].name = "eml_scalar_eg";
  c2_info[18].dominantType = "double";
  c2_info[18].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[18].fileTimeLo = 1286843996U;
  c2_info[18].fileTimeHi = 0U;
  c2_info[18].mFileTimeLo = 0U;
  c2_info[18].mFileTimeHi = 0U;
  c2_info[19].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/rem.m";
  c2_info[19].name = "eml_scalexp_alloc";
  c2_info[19].dominantType = "double";
  c2_info[19].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c2_info[19].fileTimeLo = 1330633634U;
  c2_info[19].fileTimeHi = 0U;
  c2_info[19].mFileTimeLo = 0U;
  c2_info[19].mFileTimeHi = 0U;
  c2_info[20].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[20].name = "coder.internal.cell";
  c2_info[20].dominantType = "char";
  c2_info[20].resolved =
    "[IXC]$matlabroot$/toolbox/coder/coder/+coder/+internal/cell.p";
  c2_info[20].fileTimeLo = 1342836180U;
  c2_info[20].fileTimeHi = 0U;
  c2_info[20].mFileTimeLo = 0U;
  c2_info[20].mFileTimeHi = 0U;
  c2_info[21].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[21].name = "validateattributes";
  c2_info[21].dominantType = "coder.internal.cell";
  c2_info[21].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m";
  c2_info[21].fileTimeLo = 1325899682U;
  c2_info[21].fileTimeHi = 0U;
  c2_info[21].mFileTimeLo = 0U;
  c2_info[21].mFileTimeHi = 0U;
  c2_info[22].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m";
  c2_info[22].name = "char";
  c2_info[22].dominantType = "char";
  c2_info[22].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/strfun/char.m";
  c2_info[22].fileTimeLo = 1319755168U;
  c2_info[22].fileTimeHi = 0U;
  c2_info[22].mFileTimeLo = 0U;
  c2_info[22].mFileTimeHi = 0U;
  c2_info[23].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m";
  c2_info[23].name = "isfinite";
  c2_info[23].dominantType = "";
  c2_info[23].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[23].fileTimeLo = 1286843958U;
  c2_info[23].fileTimeHi = 0U;
  c2_info[23].mFileTimeLo = 0U;
  c2_info[23].mFileTimeHi = 0U;
  c2_info[24].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m!all";
  c2_info[24].name = "isfinite";
  c2_info[24].dominantType = "double";
  c2_info[24].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[24].fileTimeLo = 1286843958U;
  c2_info[24].fileTimeHi = 0U;
  c2_info[24].mFileTimeLo = 0U;
  c2_info[24].mFileTimeHi = 0U;
  c2_info[25].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[25].name = "isinf";
  c2_info[25].dominantType = "double";
  c2_info[25].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isinf.m";
  c2_info[25].fileTimeLo = 1286843960U;
  c2_info[25].fileTimeHi = 0U;
  c2_info[25].mFileTimeLo = 0U;
  c2_info[25].mFileTimeHi = 0U;
  c2_info[26].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[26].name = "isnan";
  c2_info[26].dominantType = "double";
  c2_info[26].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c2_info[26].fileTimeLo = 1286843960U;
  c2_info[26].fileTimeHi = 0U;
  c2_info[26].mFileTimeLo = 0U;
  c2_info[26].mFileTimeHi = 0U;
  c2_info[27].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[27].name = "coder.internal.cell";
  c2_info[27].dominantType = "char";
  c2_info[27].resolved =
    "[IXC]$matlabroot$/toolbox/coder/coder/+coder/+internal/cell.p";
  c2_info[27].fileTimeLo = 1342836180U;
  c2_info[27].fileTimeHi = 0U;
  c2_info[27].mFileTimeLo = 0U;
  c2_info[27].mFileTimeHi = 0U;
  c2_info[28].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[28].name = "validateattributes";
  c2_info[28].dominantType = "coder.internal.cell";
  c2_info[28].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m";
  c2_info[28].fileTimeLo = 1325899682U;
  c2_info[28].fileTimeHi = 0U;
  c2_info[28].mFileTimeLo = 0U;
  c2_info[28].mFileTimeHi = 0U;
  c2_info[29].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[29].name = "coder.internal.cell";
  c2_info[29].dominantType = "char";
  c2_info[29].resolved =
    "[IXC]$matlabroot$/toolbox/coder/coder/+coder/+internal/cell.p";
  c2_info[29].fileTimeLo = 1342836180U;
  c2_info[29].fileTimeHi = 0U;
  c2_info[29].mFileTimeLo = 0U;
  c2_info[29].mFileTimeHi = 0U;
  c2_info[30].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[30].name = "validateattributes";
  c2_info[30].dominantType = "coder.internal.cell";
  c2_info[30].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m";
  c2_info[30].fileTimeLo = 1325899682U;
  c2_info[30].fileTimeHi = 0U;
  c2_info[30].mFileTimeLo = 0U;
  c2_info[30].mFileTimeHi = 0U;
  c2_info[31].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m";
  c2_info[31].name = "isrow";
  c2_info[31].dominantType = "double";
  c2_info[31].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/fixedpoint/isrow.m";
  c2_info[31].fileTimeLo = 1289544814U;
  c2_info[31].fileTimeHi = 0U;
  c2_info[31].mFileTimeLo = 0U;
  c2_info[31].mFileTimeHi = 0U;
  c2_info[32].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[32].name = "repmat";
  c2_info[32].dominantType = "char";
  c2_info[32].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m";
  c2_info[32].fileTimeLo = 1297372434U;
  c2_info[32].fileTimeHi = 0U;
  c2_info[32].mFileTimeLo = 0U;
  c2_info[32].mFileTimeHi = 0U;
  c2_info[33].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m";
  c2_info[33].name = "eml_assert_valid_size_arg";
  c2_info[33].dominantType = "double";
  c2_info[33].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m";
  c2_info[33].fileTimeLo = 1286843894U;
  c2_info[33].fileTimeHi = 0U;
  c2_info[33].mFileTimeLo = 0U;
  c2_info[33].mFileTimeHi = 0U;
  c2_info[34].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m!isintegral";
  c2_info[34].name = "isinf";
  c2_info[34].dominantType = "double";
  c2_info[34].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isinf.m";
  c2_info[34].fileTimeLo = 1286843960U;
  c2_info[34].fileTimeHi = 0U;
  c2_info[34].mFileTimeLo = 0U;
  c2_info[34].mFileTimeHi = 0U;
  c2_info[35].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m!numel_for_size";
  c2_info[35].name = "mtimes";
  c2_info[35].dominantType = "double";
  c2_info[35].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c2_info[35].fileTimeLo = 1289544892U;
  c2_info[35].fileTimeHi = 0U;
  c2_info[35].mFileTimeLo = 0U;
  c2_info[35].mFileTimeHi = 0U;
  c2_info[36].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m";
  c2_info[36].name = "eml_index_class";
  c2_info[36].dominantType = "";
  c2_info[36].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[36].fileTimeLo = 1323195778U;
  c2_info[36].fileTimeHi = 0U;
  c2_info[36].mFileTimeLo = 0U;
  c2_info[36].mFileTimeHi = 0U;
  c2_info[37].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m";
  c2_info[37].name = "intmax";
  c2_info[37].dominantType = "char";
  c2_info[37].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m";
  c2_info[37].fileTimeLo = 1311280516U;
  c2_info[37].fileTimeHi = 0U;
  c2_info[37].mFileTimeLo = 0U;
  c2_info[37].mFileTimeHi = 0U;
  c2_info[38].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m";
  c2_info[38].name = "eml_index_class";
  c2_info[38].dominantType = "";
  c2_info[38].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[38].fileTimeLo = 1323195778U;
  c2_info[38].fileTimeHi = 0U;
  c2_info[38].mFileTimeLo = 0U;
  c2_info[38].mFileTimeHi = 0U;
  c2_info[39].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m";
  c2_info[39].name = "eml_index_minus";
  c2_info[39].dominantType = "coder.internal.indexInt";
  c2_info[39].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_minus.m";
  c2_info[39].fileTimeLo = 1286843978U;
  c2_info[39].fileTimeHi = 0U;
  c2_info[39].mFileTimeLo = 0U;
  c2_info[39].mFileTimeHi = 0U;
  c2_info[40].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_minus.m";
  c2_info[40].name = "eml_index_class";
  c2_info[40].dominantType = "";
  c2_info[40].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[40].fileTimeLo = 1323195778U;
  c2_info[40].fileTimeHi = 0U;
  c2_info[40].mFileTimeLo = 0U;
  c2_info[40].mFileTimeHi = 0U;
  c2_info[41].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[41].name = "isfinite";
  c2_info[41].dominantType = "double";
  c2_info[41].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[41].fileTimeLo = 1286843958U;
  c2_info[41].fileTimeHi = 0U;
  c2_info[41].mFileTimeLo = 0U;
  c2_info[41].mFileTimeHi = 0U;
  c2_info[42].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[42].name = "issparse";
  c2_info[42].dominantType = "double";
  c2_info[42].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/sparfun/issparse.m";
  c2_info[42].fileTimeLo = 1286844030U;
  c2_info[42].fileTimeHi = 0U;
  c2_info[42].mFileTimeLo = 0U;
  c2_info[42].mFileTimeHi = 0U;
  c2_info[43].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[43].name = "floor";
  c2_info[43].dominantType = "double";
  c2_info[43].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c2_info[43].fileTimeLo = 1286843942U;
  c2_info[43].fileTimeHi = 0U;
  c2_info[43].mFileTimeLo = 0U;
  c2_info[43].mFileTimeHi = 0U;
  c2_info[44].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c2_info[44].name = "eml_scalar_floor";
  c2_info[44].dominantType = "double";
  c2_info[44].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
  c2_info[44].fileTimeLo = 1286843926U;
  c2_info[44].fileTimeHi = 0U;
  c2_info[44].mFileTimeLo = 0U;
  c2_info[44].mFileTimeHi = 0U;
  c2_info[45].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p";
  c2_info[45].name = "isnan";
  c2_info[45].dominantType = "double";
  c2_info[45].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c2_info[45].fileTimeLo = 1286843960U;
  c2_info[45].fileTimeHi = 0U;
  c2_info[45].mFileTimeLo = 0U;
  c2_info[45].mFileTimeHi = 0U;
  c2_info[46].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[46].name = "rem";
  c2_info[46].dominantType = "double";
  c2_info[46].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/rem.m";
  c2_info[46].fileTimeLo = 1326753198U;
  c2_info[46].fileTimeHi = 0U;
  c2_info[46].mFileTimeLo = 0U;
  c2_info[46].mFileTimeHi = 0U;
  c2_info[47].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[47].name = "any";
  c2_info[47].dominantType = "double";
  c2_info[47].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/any.m";
  c2_info[47].fileTimeLo = 1286844034U;
  c2_info[47].fileTimeHi = 0U;
  c2_info[47].mFileTimeLo = 0U;
  c2_info[47].mFileTimeHi = 0U;
  c2_info[48].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/any.m";
  c2_info[48].name = "eml_all_or_any";
  c2_info[48].dominantType = "char";
  c2_info[48].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  c2_info[48].fileTimeLo = 1286843894U;
  c2_info[48].fileTimeHi = 0U;
  c2_info[48].mFileTimeLo = 0U;
  c2_info[48].mFileTimeHi = 0U;
  c2_info[49].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  c2_info[49].name = "isequal";
  c2_info[49].dominantType = "double";
  c2_info[49].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isequal.m";
  c2_info[49].fileTimeLo = 1286843958U;
  c2_info[49].fileTimeHi = 0U;
  c2_info[49].mFileTimeLo = 0U;
  c2_info[49].mFileTimeHi = 0U;
  c2_info[50].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isequal.m";
  c2_info[50].name = "eml_isequal_core";
  c2_info[50].dominantType = "double";
  c2_info[50].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_isequal_core.m";
  c2_info[50].fileTimeLo = 1286843986U;
  c2_info[50].fileTimeHi = 0U;
  c2_info[50].mFileTimeLo = 0U;
  c2_info[50].mFileTimeHi = 0U;
  c2_info[51].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  c2_info[51].name = "eml_const_nonsingleton_dim";
  c2_info[51].dominantType = "double";
  c2_info[51].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_const_nonsingleton_dim.m";
  c2_info[51].fileTimeLo = 1286843896U;
  c2_info[51].fileTimeHi = 0U;
  c2_info[51].mFileTimeLo = 0U;
  c2_info[51].mFileTimeHi = 0U;
  c2_info[52].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  c2_info[52].name = "isnan";
  c2_info[52].dominantType = "double";
  c2_info[52].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c2_info[52].fileTimeLo = 1286843960U;
  c2_info[52].fileTimeHi = 0U;
  c2_info[52].mFileTimeLo = 0U;
  c2_info[52].mFileTimeHi = 0U;
  c2_info[53].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[53].name = "coder.internal.errorIf";
  c2_info[53].dominantType = "char";
  c2_info[53].resolved =
    "[IXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/errorIf.m";
  c2_info[53].fileTimeLo = 1334097138U;
  c2_info[53].fileTimeHi = 0U;
  c2_info[53].mFileTimeLo = 0U;
  c2_info[53].mFileTimeHi = 0U;
  c2_info[54].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[54].name = "any";
  c2_info[54].dominantType = "logical";
  c2_info[54].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/any.m";
  c2_info[54].fileTimeLo = 1286844034U;
  c2_info[54].fileTimeHi = 0U;
  c2_info[54].mFileTimeLo = 0U;
  c2_info[54].mFileTimeHi = 0U;
  c2_info[55].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  c2_info[55].name = "eml_const_nonsingleton_dim";
  c2_info[55].dominantType = "logical";
  c2_info[55].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_const_nonsingleton_dim.m";
  c2_info[55].fileTimeLo = 1286843896U;
  c2_info[55].fileTimeHi = 0U;
  c2_info[55].mFileTimeLo = 0U;
  c2_info[55].mFileTimeHi = 0U;
  c2_info[56].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  c2_info[56].name = "isnan";
  c2_info[56].dominantType = "logical";
  c2_info[56].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c2_info[56].fileTimeLo = 1286843960U;
  c2_info[56].fileTimeHi = 0U;
  c2_info[56].mFileTimeLo = 0U;
  c2_info[56].mFileTimeHi = 0U;
  c2_info[57].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[57].name = "max";
  c2_info[57].dominantType = "double";
  c2_info[57].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c2_info[57].fileTimeLo = 1311280516U;
  c2_info[57].fileTimeHi = 0U;
  c2_info[57].mFileTimeLo = 0U;
  c2_info[57].mFileTimeHi = 0U;
  c2_info[58].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c2_info[58].name = "eml_min_or_max";
  c2_info[58].dominantType = "char";
  c2_info[58].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m";
  c2_info[58].fileTimeLo = 1334096690U;
  c2_info[58].fileTimeHi = 0U;
  c2_info[58].mFileTimeLo = 0U;
  c2_info[58].mFileTimeHi = 0U;
  c2_info[59].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c2_info[59].name = "eml_const_nonsingleton_dim";
  c2_info[59].dominantType = "double";
  c2_info[59].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_const_nonsingleton_dim.m";
  c2_info[59].fileTimeLo = 1286843896U;
  c2_info[59].fileTimeHi = 0U;
  c2_info[59].mFileTimeLo = 0U;
  c2_info[59].mFileTimeHi = 0U;
  c2_info[60].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c2_info[60].name = "eml_scalar_eg";
  c2_info[60].dominantType = "double";
  c2_info[60].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[60].fileTimeLo = 1286843996U;
  c2_info[60].fileTimeHi = 0U;
  c2_info[60].mFileTimeLo = 0U;
  c2_info[60].mFileTimeHi = 0U;
  c2_info[61].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c2_info[61].name = "eml_index_class";
  c2_info[61].dominantType = "";
  c2_info[61].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[61].fileTimeLo = 1323195778U;
  c2_info[61].fileTimeHi = 0U;
  c2_info[61].mFileTimeLo = 0U;
  c2_info[61].mFileTimeHi = 0U;
  c2_info[62].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c2_info[62].name = "eml_index_class";
  c2_info[62].dominantType = "";
  c2_info[62].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[62].fileTimeLo = 1323195778U;
  c2_info[62].fileTimeHi = 0U;
  c2_info[62].mFileTimeLo = 0U;
  c2_info[62].mFileTimeHi = 0U;
  c2_info[63].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[63].name = "mrdivide";
  c2_info[63].dominantType = "double";
  c2_info[63].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[63].fileTimeLo = 1342836144U;
  c2_info[63].fileTimeHi = 0U;
  c2_info[63].mFileTimeLo = 1319755166U;
  c2_info[63].mFileTimeHi = 0U;
}

static void c2_b_info_helper(c2_ResolvedFunctionInfo c2_info[143])
{
  c2_info[64].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[64].name = "sprintf";
  c2_info[64].dominantType = "char";
  c2_info[64].resolved = "[IXMB]$matlabroot$/toolbox/matlab/strfun/sprintf";
  c2_info[64].fileTimeLo = MAX_uint32_T;
  c2_info[64].fileTimeHi = MAX_uint32_T;
  c2_info[64].mFileTimeLo = MAX_uint32_T;
  c2_info[64].mFileTimeHi = MAX_uint32_T;
  c2_info[65].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractContinuousPhasePulseWaveform.m";
  c2_info[65].name = "coder.internal.errorIf";
  c2_info[65].dominantType = "char";
  c2_info[65].resolved =
    "[IXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/errorIf.m";
  c2_info[65].fileTimeLo = 1334097138U;
  c2_info[65].fileTimeHi = 0U;
  c2_info[65].mFileTimeLo = 0U;
  c2_info[65].mFileTimeHi = 0U;
  c2_info[66].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[66].name = "rdivide";
  c2_info[66].dominantType = "double";
  c2_info[66].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c2_info[66].fileTimeLo = 1286844044U;
  c2_info[66].fileTimeHi = 0U;
  c2_info[66].mFileTimeLo = 0U;
  c2_info[66].mFileTimeHi = 0U;
  c2_info[67].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[67].name = "round";
  c2_info[67].dominantType = "double";
  c2_info[67].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/round.m";
  c2_info[67].fileTimeLo = 1286843948U;
  c2_info[67].fileTimeHi = 0U;
  c2_info[67].mFileTimeLo = 0U;
  c2_info[67].mFileTimeHi = 0U;
  c2_info[68].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/round.m";
  c2_info[68].name = "eml_scalar_round";
  c2_info[68].dominantType = "double";
  c2_info[68].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_round.m";
  c2_info[68].fileTimeLo = 1307676438U;
  c2_info[68].fileTimeHi = 0U;
  c2_info[68].mFileTimeLo = 0U;
  c2_info[68].mFileTimeHi = 0U;
  c2_info[69].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[69].name = "mrdivide";
  c2_info[69].dominantType = "double";
  c2_info[69].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[69].fileTimeLo = 1342836144U;
  c2_info[69].fileTimeHi = 0U;
  c2_info[69].mFileTimeLo = 1319755166U;
  c2_info[69].mFileTimeHi = 0U;
  c2_info[70].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[70].name = "val2ind";
  c2_info[70].dominantType = "double";
  c2_info[70].resolved = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[70].fileTimeLo = 1332459528U;
  c2_info[70].fileTimeHi = 0U;
  c2_info[70].mFileTimeLo = 0U;
  c2_info[70].mFileTimeHi = 0U;
  c2_info[71].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[71].name = "phased.internal.narginchk";
  c2_info[71].dominantType = "double";
  c2_info[71].resolved =
    "[IXE]$matlabroot$/toolbox/phased/phased/+phased/+internal/narginchk.m";
  c2_info[71].fileTimeLo = 1326736286U;
  c2_info[71].fileTimeHi = 0U;
  c2_info[71].mFileTimeLo = 0U;
  c2_info[71].mFileTimeHi = 0U;
  c2_info[72].context =
    "[IXE]$matlabroot$/toolbox/phased/phased/+phased/+internal/narginchk.m";
  c2_info[72].name = "coder.internal.assert";
  c2_info[72].dominantType = "char";
  c2_info[72].resolved =
    "[IXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/assert.m";
  c2_info[72].fileTimeLo = 1334097138U;
  c2_info[72].fileTimeHi = 0U;
  c2_info[72].mFileTimeLo = 0U;
  c2_info[72].mFileTimeHi = 0U;
  c2_info[73].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[73].name = "coder.internal.cell";
  c2_info[73].dominantType = "char";
  c2_info[73].resolved =
    "[IXC]$matlabroot$/toolbox/coder/coder/+coder/+internal/cell.p";
  c2_info[73].fileTimeLo = 1342836180U;
  c2_info[73].fileTimeHi = 0U;
  c2_info[73].mFileTimeLo = 0U;
  c2_info[73].mFileTimeHi = 0U;
  c2_info[74].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[74].name = "validateattributes";
  c2_info[74].dominantType = "coder.internal.cell";
  c2_info[74].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m";
  c2_info[74].fileTimeLo = 1325899682U;
  c2_info[74].fileTimeHi = 0U;
  c2_info[74].mFileTimeLo = 0U;
  c2_info[74].mFileTimeHi = 0U;
  c2_info[75].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/lang/validateattributes.m!notisnan";
  c2_info[75].name = "isnan";
  c2_info[75].dominantType = "double";
  c2_info[75].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c2_info[75].fileTimeLo = 1286843960U;
  c2_info[75].fileTimeHi = 0U;
  c2_info[75].mFileTimeLo = 0U;
  c2_info[75].mFileTimeHi = 0U;
  c2_info[76].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[76].name = "any";
  c2_info[76].dominantType = "logical";
  c2_info[76].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/any.m";
  c2_info[76].fileTimeLo = 1286844034U;
  c2_info[76].fileTimeHi = 0U;
  c2_info[76].mFileTimeLo = 0U;
  c2_info[76].mFileTimeHi = 0U;
  c2_info[77].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[77].name = "sprintf";
  c2_info[77].dominantType = "char";
  c2_info[77].resolved = "[IXMB]$matlabroot$/toolbox/matlab/strfun/sprintf";
  c2_info[77].fileTimeLo = MAX_uint32_T;
  c2_info[77].fileTimeHi = MAX_uint32_T;
  c2_info[77].mFileTimeLo = MAX_uint32_T;
  c2_info[77].mFileTimeHi = MAX_uint32_T;
  c2_info[78].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[78].name = "coder.internal.errorIf";
  c2_info[78].dominantType = "char";
  c2_info[78].resolved =
    "[IXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/errorIf.m";
  c2_info[78].fileTimeLo = 1334097138U;
  c2_info[78].fileTimeHi = 0U;
  c2_info[78].mFileTimeLo = 0U;
  c2_info[78].mFileTimeHi = 0U;
  c2_info[79].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[79].name = "mrdivide";
  c2_info[79].dominantType = "double";
  c2_info[79].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[79].fileTimeLo = 1342836144U;
  c2_info[79].fileTimeHi = 0U;
  c2_info[79].mFileTimeLo = 1319755166U;
  c2_info[79].mFileTimeHi = 0U;
  c2_info[80].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[80].name = "round";
  c2_info[80].dominantType = "double";
  c2_info[80].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/round.m";
  c2_info[80].fileTimeLo = 1286843948U;
  c2_info[80].fileTimeHi = 0U;
  c2_info[80].mFileTimeLo = 0U;
  c2_info[80].mFileTimeHi = 0U;
  c2_info[81].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[81].name = "abs";
  c2_info[81].dominantType = "double";
  c2_info[81].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[81].fileTimeLo = 1286843894U;
  c2_info[81].fileTimeHi = 0U;
  c2_info[81].mFileTimeLo = 0U;
  c2_info[81].mFileTimeHi = 0U;
  c2_info[82].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[82].name = "eml_scalar_abs";
  c2_info[82].dominantType = "double";
  c2_info[82].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_abs.m";
  c2_info[82].fileTimeLo = 1286843912U;
  c2_info[82].fileTimeHi = 0U;
  c2_info[82].mFileTimeLo = 0U;
  c2_info[82].mFileTimeHi = 0U;
  c2_info[83].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[83].name = "eps";
  c2_info[83].dominantType = "double";
  c2_info[83].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[83].fileTimeLo = 1326753196U;
  c2_info[83].fileTimeHi = 0U;
  c2_info[83].mFileTimeLo = 0U;
  c2_info[83].mFileTimeHi = 0U;
  c2_info[84].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[84].name = "eml_mantissa_nbits";
  c2_info[84].dominantType = "char";
  c2_info[84].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_mantissa_nbits.m";
  c2_info[84].fileTimeLo = 1307676442U;
  c2_info[84].fileTimeHi = 0U;
  c2_info[84].mFileTimeLo = 0U;
  c2_info[84].mFileTimeHi = 0U;
  c2_info[85].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_mantissa_nbits.m";
  c2_info[85].name = "eml_float_model";
  c2_info[85].dominantType = "char";
  c2_info[85].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_float_model.m";
  c2_info[85].fileTimeLo = 1326753196U;
  c2_info[85].fileTimeHi = 0U;
  c2_info[85].mFileTimeLo = 0U;
  c2_info[85].mFileTimeHi = 0U;
  c2_info[86].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[86].name = "eml_realmin";
  c2_info[86].dominantType = "char";
  c2_info[86].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_realmin.m";
  c2_info[86].fileTimeLo = 1307676444U;
  c2_info[86].fileTimeHi = 0U;
  c2_info[86].mFileTimeLo = 0U;
  c2_info[86].mFileTimeHi = 0U;
  c2_info[87].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_realmin.m";
  c2_info[87].name = "eml_float_model";
  c2_info[87].dominantType = "char";
  c2_info[87].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_float_model.m";
  c2_info[87].fileTimeLo = 1326753196U;
  c2_info[87].fileTimeHi = 0U;
  c2_info[87].mFileTimeLo = 0U;
  c2_info[87].mFileTimeHi = 0U;
  c2_info[88].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[88].name = "eml_realmin_denormal";
  c2_info[88].dominantType = "char";
  c2_info[88].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_realmin_denormal.m";
  c2_info[88].fileTimeLo = 1326753198U;
  c2_info[88].fileTimeHi = 0U;
  c2_info[88].mFileTimeLo = 0U;
  c2_info[88].mFileTimeHi = 0U;
  c2_info[89].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_realmin_denormal.m";
  c2_info[89].name = "eml_float_model";
  c2_info[89].dominantType = "char";
  c2_info[89].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_float_model.m";
  c2_info[89].fileTimeLo = 1326753196U;
  c2_info[89].fileTimeHi = 0U;
  c2_info[89].mFileTimeLo = 0U;
  c2_info[89].mFileTimeHi = 0U;
  c2_info[90].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[90].name = "abs";
  c2_info[90].dominantType = "double";
  c2_info[90].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[90].fileTimeLo = 1286843894U;
  c2_info[90].fileTimeHi = 0U;
  c2_info[90].mFileTimeLo = 0U;
  c2_info[90].mFileTimeHi = 0U;
  c2_info[91].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[91].name = "isfinite";
  c2_info[91].dominantType = "double";
  c2_info[91].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[91].fileTimeLo = 1286843958U;
  c2_info[91].fileTimeHi = 0U;
  c2_info[91].mFileTimeLo = 0U;
  c2_info[91].mFileTimeHi = 0U;
  c2_info[92].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[92].name = "mtimes";
  c2_info[92].dominantType = "double";
  c2_info[92].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c2_info[92].fileTimeLo = 1289544892U;
  c2_info[92].fileTimeHi = 0U;
  c2_info[92].mFileTimeLo = 0U;
  c2_info[92].mFileTimeHi = 0U;
  c2_info[93].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[93].name = "find";
  c2_info[93].dominantType = "logical";
  c2_info[93].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/find.m";
  c2_info[93].fileTimeLo = 1303171406U;
  c2_info[93].fileTimeHi = 0U;
  c2_info[93].mFileTimeLo = 0U;
  c2_info[93].mFileTimeHi = 0U;
  c2_info[94].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/find.m!eml_find";
  c2_info[94].name = "eml_index_class";
  c2_info[94].dominantType = "";
  c2_info[94].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[94].fileTimeLo = 1323195778U;
  c2_info[94].fileTimeHi = 0U;
  c2_info[94].mFileTimeLo = 0U;
  c2_info[94].mFileTimeHi = 0U;
  c2_info[95].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/find.m!eml_find";
  c2_info[95].name = "eml_scalar_eg";
  c2_info[95].dominantType = "logical";
  c2_info[95].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[95].fileTimeLo = 1286843996U;
  c2_info[95].fileTimeHi = 0U;
  c2_info[95].mFileTimeLo = 0U;
  c2_info[95].mFileTimeHi = 0U;
  c2_info[96].context = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[96].name = "ceil";
  c2_info[96].dominantType = "double";
  c2_info[96].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/ceil.m";
  c2_info[96].fileTimeLo = 1286843906U;
  c2_info[96].fileTimeHi = 0U;
  c2_info[96].mFileTimeLo = 0U;
  c2_info[96].mFileTimeHi = 0U;
  c2_info[97].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/ceil.m";
  c2_info[97].name = "eml_scalar_ceil";
  c2_info[97].dominantType = "double";
  c2_info[97].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_ceil.m";
  c2_info[97].fileTimeLo = 1286843920U;
  c2_info[97].fileTimeHi = 0U;
  c2_info[97].mFileTimeLo = 0U;
  c2_info[97].mFileTimeHi = 0U;
  c2_info[98].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[98].name = "cumsum";
  c2_info[98].dominantType = "double";
  c2_info[98].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/cumsum.m";
  c2_info[98].fileTimeLo = 1286843884U;
  c2_info[98].fileTimeHi = 0U;
  c2_info[98].mFileTimeLo = 0U;
  c2_info[98].mFileTimeHi = 0U;
  c2_info[99].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/cumsum.m";
  c2_info[99].name = "eml_nonsingleton_dim";
  c2_info[99].dominantType = "double";
  c2_info[99].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_nonsingleton_dim.m";
  c2_info[99].fileTimeLo = 1307676442U;
  c2_info[99].fileTimeHi = 0U;
  c2_info[99].mFileTimeLo = 0U;
  c2_info[99].mFileTimeHi = 0U;
  c2_info[100].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_nonsingleton_dim.m";
  c2_info[100].name = "eml_index_class";
  c2_info[100].dominantType = "";
  c2_info[100].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[100].fileTimeLo = 1323195778U;
  c2_info[100].fileTimeHi = 0U;
  c2_info[100].mFileTimeLo = 0U;
  c2_info[100].mFileTimeHi = 0U;
  c2_info[101].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[101].name = "sum";
  c2_info[101].dominantType = "double";
  c2_info[101].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/sum.m";
  c2_info[101].fileTimeLo = 1314761812U;
  c2_info[101].fileTimeHi = 0U;
  c2_info[101].mFileTimeLo = 0U;
  c2_info[101].mFileTimeHi = 0U;
  c2_info[102].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/sum.m";
  c2_info[102].name = "isequal";
  c2_info[102].dominantType = "double";
  c2_info[102].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isequal.m";
  c2_info[102].fileTimeLo = 1286843958U;
  c2_info[102].fileTimeHi = 0U;
  c2_info[102].mFileTimeLo = 0U;
  c2_info[102].mFileTimeHi = 0U;
  c2_info[103].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/sum.m";
  c2_info[103].name = "eml_const_nonsingleton_dim";
  c2_info[103].dominantType = "double";
  c2_info[103].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_const_nonsingleton_dim.m";
  c2_info[103].fileTimeLo = 1286843896U;
  c2_info[103].fileTimeHi = 0U;
  c2_info[103].mFileTimeLo = 0U;
  c2_info[103].mFileTimeHi = 0U;
  c2_info[104].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[104].name = "mrdivide";
  c2_info[104].dominantType = "double";
  c2_info[104].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[104].fileTimeLo = 1342836144U;
  c2_info[104].fileTimeHi = 0U;
  c2_info[104].mFileTimeLo = 1319755166U;
  c2_info[104].mFileTimeHi = 0U;
  c2_info[105].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[105].name = "val2ind";
  c2_info[105].dominantType = "double";
  c2_info[105].resolved = "[IXE]$matlabroot$/toolbox/phased/phased/val2ind.m";
  c2_info[105].fileTimeLo = 1332459528U;
  c2_info[105].fileTimeHi = 0U;
  c2_info[105].mFileTimeLo = 0U;
  c2_info[105].mFileTimeHi = 0U;
  c2_info[106].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[106].name = "colon";
  c2_info[106].dominantType = "double";
  c2_info[106].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[106].fileTimeLo = 1311280518U;
  c2_info[106].fileTimeHi = 0U;
  c2_info[106].mFileTimeLo = 0U;
  c2_info[106].mFileTimeHi = 0U;
  c2_info[107].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!is_flint_colon";
  c2_info[107].name = "isfinite";
  c2_info[107].dominantType = "double";
  c2_info[107].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[107].fileTimeLo = 1286843958U;
  c2_info[107].fileTimeHi = 0U;
  c2_info[107].mFileTimeLo = 0U;
  c2_info[107].mFileTimeHi = 0U;
  c2_info[108].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!is_flint_colon";
  c2_info[108].name = "floor";
  c2_info[108].dominantType = "double";
  c2_info[108].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c2_info[108].fileTimeLo = 1286843942U;
  c2_info[108].fileTimeHi = 0U;
  c2_info[108].mFileTimeLo = 0U;
  c2_info[108].mFileTimeHi = 0U;
  c2_info[109].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!maxabs";
  c2_info[109].name = "abs";
  c2_info[109].dominantType = "double";
  c2_info[109].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[109].fileTimeLo = 1286843894U;
  c2_info[109].fileTimeHi = 0U;
  c2_info[109].mFileTimeLo = 0U;
  c2_info[109].mFileTimeHi = 0U;
  c2_info[110].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!is_flint_colon";
  c2_info[110].name = "eps";
  c2_info[110].dominantType = "double";
  c2_info[110].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[110].fileTimeLo = 1326753196U;
  c2_info[110].fileTimeHi = 0U;
  c2_info[110].mFileTimeLo = 0U;
  c2_info[110].mFileTimeHi = 0U;
  c2_info[111].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!checkrange";
  c2_info[111].name = "realmax";
  c2_info[111].dominantType = "char";
  c2_info[111].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/realmax.m";
  c2_info[111].fileTimeLo = 1307676442U;
  c2_info[111].fileTimeHi = 0U;
  c2_info[111].mFileTimeLo = 0U;
  c2_info[111].mFileTimeHi = 0U;
  c2_info[112].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/realmax.m";
  c2_info[112].name = "eml_realmax";
  c2_info[112].dominantType = "char";
  c2_info[112].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_realmax.m";
  c2_info[112].fileTimeLo = 1326753196U;
  c2_info[112].fileTimeHi = 0U;
  c2_info[112].mFileTimeLo = 0U;
  c2_info[112].mFileTimeHi = 0U;
  c2_info[113].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_realmax.m";
  c2_info[113].name = "eml_float_model";
  c2_info[113].dominantType = "char";
  c2_info[113].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_float_model.m";
  c2_info[113].fileTimeLo = 1326753196U;
  c2_info[113].fileTimeHi = 0U;
  c2_info[113].mFileTimeLo = 0U;
  c2_info[113].mFileTimeHi = 0U;
  c2_info[114].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_realmax.m";
  c2_info[114].name = "mtimes";
  c2_info[114].dominantType = "double";
  c2_info[114].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c2_info[114].fileTimeLo = 1289544892U;
  c2_info[114].fileTimeHi = 0U;
  c2_info[114].mFileTimeLo = 0U;
  c2_info[114].mFileTimeHi = 0U;
  c2_info[115].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!eml_flint_colon";
  c2_info[115].name = "mrdivide";
  c2_info[115].dominantType = "double";
  c2_info[115].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[115].fileTimeLo = 1342836144U;
  c2_info[115].fileTimeHi = 0U;
  c2_info[115].mFileTimeLo = 1319755166U;
  c2_info[115].mFileTimeHi = 0U;
  c2_info[116].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!eml_flint_colon";
  c2_info[116].name = "floor";
  c2_info[116].dominantType = "double";
  c2_info[116].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c2_info[116].fileTimeLo = 1286843942U;
  c2_info[116].fileTimeHi = 0U;
  c2_info[116].mFileTimeLo = 0U;
  c2_info[116].mFileTimeHi = 0U;
  c2_info[117].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!eml_flint_colon";
  c2_info[117].name = "eml_index_class";
  c2_info[117].dominantType = "";
  c2_info[117].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c2_info[117].fileTimeLo = 1323195778U;
  c2_info[117].fileTimeHi = 0U;
  c2_info[117].mFileTimeLo = 0U;
  c2_info[117].mFileTimeHi = 0U;
  c2_info[118].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m!eml_flint_colon";
  c2_info[118].name = "intmax";
  c2_info[118].dominantType = "char";
  c2_info[118].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m";
  c2_info[118].fileTimeLo = 1311280516U;
  c2_info[118].fileTimeHi = 0U;
  c2_info[118].mFileTimeLo = 0U;
  c2_info[118].mFileTimeHi = 0U;
  c2_info[119].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[119].name = "mtimes";
  c2_info[119].dominantType = "double";
  c2_info[119].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c2_info[119].fileTimeLo = 1289544892U;
  c2_info[119].fileTimeHi = 0U;
  c2_info[119].mFileTimeLo = 0U;
  c2_info[119].mFileTimeHi = 0U;
  c2_info[120].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[120].name = "power";
  c2_info[120].dominantType = "double";
  c2_info[120].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c2_info[120].fileTimeLo = 1336547296U;
  c2_info[120].fileTimeHi = 0U;
  c2_info[120].mFileTimeLo = 0U;
  c2_info[120].mFileTimeHi = 0U;
  c2_info[121].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c2_info[121].name = "eml_scalar_eg";
  c2_info[121].dominantType = "double";
  c2_info[121].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[121].fileTimeLo = 1286843996U;
  c2_info[121].fileTimeHi = 0U;
  c2_info[121].mFileTimeLo = 0U;
  c2_info[121].mFileTimeHi = 0U;
  c2_info[122].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c2_info[122].name = "eml_scalexp_alloc";
  c2_info[122].dominantType = "double";
  c2_info[122].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c2_info[122].fileTimeLo = 1330633634U;
  c2_info[122].fileTimeHi = 0U;
  c2_info[122].mFileTimeLo = 0U;
  c2_info[122].mFileTimeHi = 0U;
  c2_info[123].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c2_info[123].name = "floor";
  c2_info[123].dominantType = "double";
  c2_info[123].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c2_info[123].fileTimeLo = 1286843942U;
  c2_info[123].fileTimeHi = 0U;
  c2_info[123].mFileTimeLo = 0U;
  c2_info[123].mFileTimeHi = 0U;
  c2_info[124].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/LinearFMWaveform.m";
  c2_info[124].name = "exp";
  c2_info[124].dominantType = "double";
  c2_info[124].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/exp.m";
  c2_info[124].fileTimeLo = 1286843940U;
  c2_info[124].fileTimeHi = 0U;
  c2_info[124].mFileTimeLo = 0U;
  c2_info[124].mFileTimeHi = 0U;
  c2_info[125].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/exp.m";
  c2_info[125].name = "eml_scalar_exp";
  c2_info[125].dominantType = "double";
  c2_info[125].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_exp.m";
  c2_info[125].fileTimeLo = 1301353664U;
  c2_info[125].fileTimeHi = 0U;
  c2_info[125].mFileTimeLo = 0U;
  c2_info[125].mFileTimeHi = 0U;
  c2_info[126].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_exp.m";
  c2_info[126].name = "mrdivide";
  c2_info[126].dominantType = "double";
  c2_info[126].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c2_info[126].fileTimeLo = 1342836144U;
  c2_info[126].fileTimeHi = 0U;
  c2_info[126].mFileTimeLo = 1319755166U;
  c2_info[126].mFileTimeHi = 0U;
  c2_info[127].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[127].name = "colon";
  c2_info[127].dominantType = "double";
  c2_info[127].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[127].fileTimeLo = 1311280518U;
  c2_info[127].fileTimeHi = 0U;
  c2_info[127].mFileTimeLo = 0U;
  c2_info[127].mFileTimeHi = 0U;
}

static void c2_c_info_helper(c2_ResolvedFunctionInfo c2_info[143])
{
  c2_info[128].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p";
  c2_info[128].name = "matlab.system.coder.SystemCore";
  c2_info[128].dominantType = "";
  c2_info[128].resolved =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p";
  c2_info[128].fileTimeLo = 1342833426U;
  c2_info[128].fileTimeHi = 0U;
  c2_info[128].mFileTimeLo = 0U;
  c2_info[128].mFileTimeHi = 0U;
  c2_info[129].context =
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p";
  c2_info[129].name = "length";
  c2_info[129].dominantType = "logical";
  c2_info[129].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/length.m";
  c2_info[129].fileTimeLo = 1303171406U;
  c2_info[129].fileTimeHi = 0U;
  c2_info[129].mFileTimeLo = 0U;
  c2_info[129].mFileTimeHi = 0U;
  c2_info[130].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[130].name = "mod";
  c2_info[130].dominantType = "double";
  c2_info[130].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m";
  c2_info[130].fileTimeLo = 1326753196U;
  c2_info[130].fileTimeHi = 0U;
  c2_info[130].mFileTimeLo = 0U;
  c2_info[130].mFileTimeHi = 0U;
  c2_info[131].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m";
  c2_info[131].name = "eml_scalar_eg";
  c2_info[131].dominantType = "double";
  c2_info[131].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[131].fileTimeLo = 1286843996U;
  c2_info[131].fileTimeHi = 0U;
  c2_info[131].mFileTimeLo = 0U;
  c2_info[131].mFileTimeHi = 0U;
  c2_info[132].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m";
  c2_info[132].name = "eml_scalexp_alloc";
  c2_info[132].dominantType = "double";
  c2_info[132].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c2_info[132].fileTimeLo = 1330633634U;
  c2_info[132].fileTimeHi = 0U;
  c2_info[132].mFileTimeLo = 0U;
  c2_info[132].mFileTimeHi = 0U;
  c2_info[133].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m!floatmod";
  c2_info[133].name = "eml_scalar_eg";
  c2_info[133].dominantType = "double";
  c2_info[133].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[133].fileTimeLo = 1286843996U;
  c2_info[133].fileTimeHi = 0U;
  c2_info[133].mFileTimeLo = 0U;
  c2_info[133].mFileTimeHi = 0U;
  c2_info[134].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m!floatmod";
  c2_info[134].name = "eml_scalar_floor";
  c2_info[134].dominantType = "double";
  c2_info[134].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
  c2_info[134].fileTimeLo = 1286843926U;
  c2_info[134].fileTimeHi = 0U;
  c2_info[134].mFileTimeLo = 0U;
  c2_info[134].mFileTimeHi = 0U;
  c2_info[135].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m!floatmod";
  c2_info[135].name = "eml_scalar_round";
  c2_info[135].dominantType = "double";
  c2_info[135].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_round.m";
  c2_info[135].fileTimeLo = 1307676438U;
  c2_info[135].fileTimeHi = 0U;
  c2_info[135].mFileTimeLo = 0U;
  c2_info[135].mFileTimeHi = 0U;
  c2_info[136].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m!floatmod";
  c2_info[136].name = "eml_scalar_abs";
  c2_info[136].dominantType = "double";
  c2_info[136].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_abs.m";
  c2_info[136].fileTimeLo = 1286843912U;
  c2_info[136].fileTimeHi = 0U;
  c2_info[136].mFileTimeLo = 0U;
  c2_info[136].mFileTimeHi = 0U;
  c2_info[137].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m!floatmod";
  c2_info[137].name = "eps";
  c2_info[137].dominantType = "char";
  c2_info[137].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[137].fileTimeLo = 1326753196U;
  c2_info[137].fileTimeHi = 0U;
  c2_info[137].mFileTimeLo = 0U;
  c2_info[137].mFileTimeHi = 0U;
  c2_info[138].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[138].name = "eml_is_float_class";
  c2_info[138].dominantType = "char";
  c2_info[138].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_is_float_class.m";
  c2_info[138].fileTimeLo = 1286843982U;
  c2_info[138].fileTimeHi = 0U;
  c2_info[138].mFileTimeLo = 0U;
  c2_info[138].mFileTimeHi = 0U;
  c2_info[139].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[139].name = "eml_eps";
  c2_info[139].dominantType = "char";
  c2_info[139].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_eps.m";
  c2_info[139].fileTimeLo = 1326753196U;
  c2_info[139].fileTimeHi = 0U;
  c2_info[139].mFileTimeLo = 0U;
  c2_info[139].mFileTimeHi = 0U;
  c2_info[140].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_eps.m";
  c2_info[140].name = "eml_float_model";
  c2_info[140].dominantType = "char";
  c2_info[140].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_float_model.m";
  c2_info[140].fileTimeLo = 1326753196U;
  c2_info[140].fileTimeHi = 0U;
  c2_info[140].mFileTimeLo = 0U;
  c2_info[140].mFileTimeHi = 0U;
  c2_info[141].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/mod.m!floatmod";
  c2_info[141].name = "mtimes";
  c2_info[141].dominantType = "double";
  c2_info[141].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c2_info[141].fileTimeLo = 1289544892U;
  c2_info[141].fileTimeHi = 0U;
  c2_info[141].mFileTimeLo = 0U;
  c2_info[141].mFileTimeHi = 0U;
  c2_info[142].context =
    "[IXC]$matlabroot$/toolbox/phased/phased/+phased/+internal/AbstractPulseWaveform.m";
  c2_info[142].name = "find";
  c2_info[142].dominantType = "logical";
  c2_info[142].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/find.m";
  c2_info[142].fileTimeLo = 1303171406U;
  c2_info[142].fileTimeHi = 0U;
  c2_info[142].mFileTimeLo = 0U;
  c2_info[142].mFileTimeHi = 0U;
}

static void c2_cell_cell(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static void c2_iscellstr(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static void c2_isconstcell(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance)
{
}

static void c2_SystemProp_matlabCodegenSetAnyProp
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj)
{
  c2_cell_cell(chartInstance);
  c2_iscellstr(chartInstance);
  c2_isconstcell(chartInstance);
}

static void c2_b_SystemProp_matlabCodegenSetAnyProp
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj)
{
  c2_cell_cell(chartInstance);
  c2_iscellstr(chartInstance);
  c2_isconstcell(chartInstance);
}

static void c2_c_SystemProp_matlabCodegenSetAnyProp
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj)
{
  c2_iscellstr(chartInstance);
  c2_isconstcell(chartInstance);
}

static void c2_pvParse(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
  c2_phased_LinearFMWaveform *c2_obj)
{
  c2_SystemProp_matlabCodegenSetAnyProp(chartInstance, c2_obj);
  c2_b_SystemProp_matlabCodegenSetAnyProp(chartInstance, c2_obj);
  c2_c_SystemProp_matlabCodegenSetAnyProp(chartInstance, c2_obj);
  c2_cell_cell(chartInstance);
  c2_iscellstr(chartInstance);
  c2_isconstcell(chartInstance);
}

static creal_T c2_SystemCore_step(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, c2_phased_LinearFMWaveform *c2_obj)
{
  int32_T c2_i1;
  static char_T c2_cv0[45] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'y', 's',
    't', 'e', 'm', ':', 'm', 'e', 't', 'h', 'o', 'd', 'C', 'a', 'l', 'l', 'e',
    'd', 'W', 'h', 'e', 'n', 'R', 'e', 'l', 'e', 'a', 's', 'e', 'd', 'C', 'o',
    'd', 'e', 'g', 'e', 'n' };

  char_T c2_u[45];
  const mxArray *c2_y = NULL;
  int32_T c2_i2;
  static char_T c2_cv1[4] = { 's', 't', 'e', 'p' };

  char_T c2_b_u[4];
  const mxArray *c2_b_y = NULL;
  c2_phased_LinearFMWaveform *c2_b_obj;
  int32_T c2_i3;
  static char_T c2_cv2[51] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'y', 's',
    't', 'e', 'm', ':', 'm', 'e', 't', 'h', 'o', 'd', 'C', 'a', 'l', 'l', 'e',
    'd', 'W', 'h', 'e', 'n', 'L', 'o', 'c', 'k', 'e', 'd', 'R', 'e', 'l', 'e',
    'a', 's', 'e', 'd', 'C', 'o', 'd', 'e', 'g', 'e', 'n' };

  char_T c2_c_u[51];
  const mxArray *c2_c_y = NULL;
  int32_T c2_i4;
  static char_T c2_cv3[5] = { 's', 'e', 't', 'u', 'p' };

  char_T c2_d_u[5];
  const mxArray *c2_d_y = NULL;
  c2_phased_LinearFMWaveform *c2_c_obj;
  c2_phased_LinearFMWaveform *c2_d_obj;
  c2_phased_LinearFMWaveform *c2_e_obj;
  c2_phased_LinearFMWaveform *c2_f_obj;
  c2_phased_LinearFMWaveform *c2_g_obj;
  int32_T c2_i5;
  c2_phased_LinearFMWaveform *c2_h_obj;
  c2_phased_LinearFMWaveform *c2_i_obj;
  c2_phased_LinearFMWaveform *c2_j_obj;
  if (!c2_obj->isReleased) {
  } else {
    for (c2_i1 = 0; c2_i1 < 45; c2_i1++) {
      c2_u[c2_i1] = c2_cv0[c2_i1];
    }

    c2_y = NULL;
    sf_mex_assign(&c2_y, sf_mex_create("y", c2_u, 10, 0U, 1U, 0U, 2, 1, 45),
                  FALSE);
    for (c2_i2 = 0; c2_i2 < 4; c2_i2++) {
      c2_b_u[c2_i2] = c2_cv1[c2_i2];
    }

    c2_b_y = NULL;
    sf_mex_assign(&c2_b_y, sf_mex_create("y", c2_b_u, 10, 0U, 1U, 0U, 2, 1, 4),
                  FALSE);
    sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 2U,
      14, c2_y, 14, c2_b_y));
  }

  if (!c2_obj->isInitialized) {
    c2_b_obj = c2_obj;
    if (!c2_b_obj->isInitialized) {
    } else {
      for (c2_i3 = 0; c2_i3 < 51; c2_i3++) {
        c2_c_u[c2_i3] = c2_cv2[c2_i3];
      }

      c2_c_y = NULL;
      sf_mex_assign(&c2_c_y, sf_mex_create("y", c2_c_u, 10, 0U, 1U, 0U, 2, 1, 51),
                    FALSE);
      for (c2_i4 = 0; c2_i4 < 5; c2_i4++) {
        c2_d_u[c2_i4] = c2_cv3[c2_i4];
      }

      c2_d_y = NULL;
      sf_mex_assign(&c2_d_y, sf_mex_create("y", c2_d_u, 10, 0U, 1U, 0U, 2, 1, 5),
                    FALSE);
      sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 2U,
        14, c2_c_y, 14, c2_d_y));
    }

    c2_c_obj = c2_b_obj;
    c2_c_obj->isInitialized = TRUE;
    c2_d_obj = c2_b_obj;
    c2_AbstractContinuousPhasePulseWaveform_validatePropertiesImpl(chartInstance,
      c2_d_obj);
    c2_AbstractPulseWaveform_setupImpl(chartInstance, c2_b_obj);
    c2_e_obj = c2_b_obj;
    c2_f_obj = c2_e_obj;
    c2_f_obj->pOutputStartSampleIndex = 1.0;
    c2_realmax(chartInstance);
    c2_g_obj = c2_e_obj;
    for (c2_i5 = 0; c2_i5 < 2; c2_i5++) {
      c2_g_obj->pOutputSampleInterval[c2_i5] = (real_T)c2_i5;
    }

    c2_h_obj = c2_b_obj;
    c2_h_obj->TunablePropsChanged = FALSE;
  }

  c2_i_obj = c2_obj;
  if (c2_i_obj->TunablePropsChanged) {
    c2_AbstractContinuousPhasePulseWaveform_validatePropertiesImpl(chartInstance,
      c2_i_obj);
    c2_j_obj = c2_i_obj;
    c2_j_obj->TunablePropsChanged = FALSE;
  }

  return c2_AbstractPulseWaveform_stepImpl(chartInstance, c2_obj);
}

static void c2_AbstractContinuousPhasePulseWaveform_validatePropertiesImpl
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj)
{
  boolean_T c2_u;
  const mxArray *c2_y = NULL;
  int32_T c2_i6;
  static char_T c2_cv4[36] = { 'p', 'h', 'a', 's', 'e', 'd', ':', 'W', 'a', 'v',
    'e', 'f', 'o', 'r', 'm', ':', 'N', 'o', 't', 'L', 'e', 's', 's', 'T', 'h',
    'a', 'n', 'O', 'r', 'E', 'q', 'u', 'a', 'l', 'T', 'o' };

  char_T c2_b_u[36];
  const mxArray *c2_b_y = NULL;
  int32_T c2_i7;
  static char_T c2_cv5[10] = { 'P', 'u', 'l', 's', 'e', 'W', 'i', 'd', 't', 'h'
  };

  char_T c2_c_u[10];
  const mxArray *c2_c_y = NULL;
  int32_T c2_i8;
  static char_T c2_cv6[5] = { '%', '5', '.', '2', 'e' };

  char_T c2_d_u[5];
  const mxArray *c2_d_y = NULL;
  real_T c2_e_u;
  const mxArray *c2_e_y = NULL;
  c2_any(chartInstance, FALSE);
  c2_u = FALSE;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 11, 0U, 0U, 0U, 0), FALSE);
  for (c2_i6 = 0; c2_i6 < 36; c2_i6++) {
    c2_b_u[c2_i6] = c2_cv4[c2_i6];
  }

  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", c2_b_u, 10, 0U, 1U, 0U, 2, 1, 36),
                FALSE);
  for (c2_i7 = 0; c2_i7 < 10; c2_i7++) {
    c2_c_u[c2_i7] = c2_cv5[c2_i7];
  }

  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", c2_c_u, 10, 0U, 1U, 0U, 2, 1, 10),
                FALSE);
  for (c2_i8 = 0; c2_i8 < 5; c2_i8++) {
    c2_d_u[c2_i8] = c2_cv6[c2_i8];
  }

  c2_d_y = NULL;
  sf_mex_assign(&c2_d_y, sf_mex_create("y", c2_d_u, 10, 0U, 1U, 0U, 2, 1, 5),
                FALSE);
  c2_e_u = 3.3333333333333335E-5;
  c2_e_y = NULL;
  sf_mex_assign(&c2_e_y, sf_mex_create("y", &c2_e_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_call_debug("coder.internal.errorIf", 0U, 4U, 14, c2_y, 14, c2_b_y, 14,
                    c2_c_y, 14, sf_mex_call_debug("sprintf", 1U, 2U, 14, c2_d_y,
    14, c2_e_y));
}

static boolean_T c2_any(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
  boolean_T c2_x)
{
  return FALSE;
}

static void c2_AbstractPulseWaveform_setupImpl
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj)
{
  c2_val2ind(chartInstance);
  c2_val2ind(chartInstance);
  c2_realmax(chartInstance);
}

static void c2_narginchk(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static void c2_b_iscellstr(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance)
{
}

static void c2_b_isconstcell(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance)
{
}

static void c2_val2ind(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
  boolean_T c2_u;
  const mxArray *c2_y = NULL;
  int32_T c2_i9;
  static char_T c2_cv7[25] = { 'p', 'h', 'a', 's', 'e', 'd', ':', 'v', 'a', 'l',
    '2', 'i', 'n', 'd', ':', 'O', 'u', 't', 'O', 'f', 'R', 'a', 'n', 'g', 'e' };

  char_T c2_b_u[25];
  const mxArray *c2_b_y = NULL;
  int32_T c2_i10;
  static char_T c2_cv8[5] = { '%', '5', '.', '2', 'f' };

  char_T c2_c_u[5];
  const mxArray *c2_c_y = NULL;
  real_T c2_d_u;
  const mxArray *c2_d_y = NULL;
  c2_narginchk(chartInstance);
  c2_validateattributes(chartInstance);
  c2_b_validateattributes(chartInstance);
  c2_b_iscellstr(chartInstance);
  c2_b_isconstcell(chartInstance);
  c2_any(chartInstance, FALSE);
  c2_u = FALSE;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 11, 0U, 0U, 0U, 0), FALSE);
  for (c2_i9 = 0; c2_i9 < 25; c2_i9++) {
    c2_b_u[c2_i9] = c2_cv7[c2_i9];
  }

  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", c2_b_u, 10, 0U, 1U, 0U, 2, 1, 25),
                FALSE);
  for (c2_i10 = 0; c2_i10 < 5; c2_i10++) {
    c2_c_u[c2_i10] = c2_cv8[c2_i10];
  }

  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", c2_c_u, 10, 0U, 1U, 0U, 2, 1, 5),
                FALSE);
  c2_d_u = 0.0;
  c2_d_y = NULL;
  sf_mex_assign(&c2_d_y, sf_mex_create("y", &c2_d_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_call_debug("coder.internal.errorIf", 0U, 3U, 14, c2_y, 14, c2_b_y, 14,
                    sf_mex_call_debug("sprintf", 1U, 2U, 14, c2_c_y, 14, c2_d_y));
}

static void c2_validateattributes(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance)
{
  c2_b_iscellstr(chartInstance);
  c2_b_isconstcell(chartInstance);
}

static void c2_b_validateattributes(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance)
{
  c2_b_iscellstr(chartInstance);
  c2_b_isconstcell(chartInstance);
}

static void c2_realmax(SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance)
{
}

static creal_T c2_AbstractPulseWaveform_stepImpl
  (SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance,
   c2_phased_LinearFMWaveform *c2_obj)
{
  creal_T c2_y;
  int32_T c2_i11;
  real_T c2_OutputSampleIndex[2];
  int32_T c2_i12;
  int32_T c2_k;
  real_T c2_b_k;
  real_T c2_xk;
  real_T c2_x;
  real_T c2_b_x;
  real_T c2_c_x;
  real_T c2_r;
  real_T c2_b_r[2];
  int32_T c2_i13;
  c2_phased_LinearFMWaveform *c2_b_obj;
  real_T c2_value;
  static creal_T c2_dc1 = { 0.0, 0.0 };

  boolean_T c2_b0;
  boolean_T c2_b1;
  boolean_T c2_d_x;
  boolean_T c2_e_x;
  int32_T c2_ii_sizes[2];
  int32_T c2_ii;
  int32_T c2_b_ii;
  int32_T c2_ii_data[1];
  int32_T c2_c_ii;
  int32_T c2_d_ii;
  int32_T c2_currentPulseIdx_sizes[2];
  int32_T c2_currentPulseIdx;
  int32_T c2_b_currentPulseIdx;
  int32_T c2_loop_ub;
  int32_T c2_i14;
  real_T c2_currentPulseIdx_data[1];
  boolean_T c2_b2;
  boolean_T c2_b3;
  int32_T c2_i15;
  int32_T c2_iv0[2];
  int32_T c2_sampleIdx_sizes[2];
  int32_T c2_sampleIdx;
  int32_T c2_b_sampleIdx;
  int32_T c2_b_loop_ub;
  int32_T c2_i16;
  real_T c2_sampleIdx_data[1];
  int32_T c2_e_ii;
  int32_T c2_f_ii;
  int32_T c2_c_loop_ub;
  int32_T c2_i17;
  int32_T c2_c_currentPulseIdx;
  int32_T c2_d_currentPulseIdx;
  int32_T c2_d_loop_ub;
  int32_T c2_i18;
  int32_T c2_c_sampleIdx[1];
  int32_T c2_tmp_sizes;
  int32_T c2_e_loop_ub;
  int32_T c2_i19;
  static creal_T c2_dcv0[40] = { { 1.0, 0.0 }, { 0.9992290362407229,
      0.039259815759068617 }, { 0.98768834059513777, 0.1564344650402309 }, {
      0.93819133592248416, 0.34611705707749296 }, { 0.80901699437494734,
      0.58778525229247325 }, { 0.55557023301960229, 0.83146961230254524 }, {
      0.15643446504023092, 0.98768834059513777 }, { -0.34611705707749268,
      0.93819133592248427 }, { -0.80901699437494767, 0.5877852522924728 }, { -
      0.9992290362407229, -0.039259815759069151 }, { -0.70710678118654768,
      -0.70710678118654746 }, { 0.039259815759068645, -0.9992290362407229 }, {
      0.80901699437494734, -0.58778525229247336 }, { 0.93819133592248449,
      0.34611705707749213 }, { 0.15643446504023203, 0.98768834059513755 }, { -
      0.83146961230254612, 0.55557023301960085 }, { -0.80901699437494656,
      -0.58778525229247425 }, { 0.34611705707749446, -0.9381913359224836 }, {
      0.98768834059513744, 0.156434465040233 }, { -0.039259815759070053,
      0.9992290362407229 }, { -1.0, 6.1232339957367663E-16 }, {
      0.039259815759068159, -0.9992290362407229 }, { 0.98768834059513766,
      0.156434465040231 }, { -0.3461170570774974, 0.93819133592248249 }, { -
      0.8090169943749479, -0.58778525229247247 }, { 0.83146961230254779,
      -0.5555702330195984 }, { 0.15643446504023453, 0.9876883405951371 }, { -
      0.93819133592248316, -0.34611705707749546 }, { 0.80901699437494468,
      -0.587785252292477 }, { -0.039259815759067541, 0.999229036240723 }, { -
      0.7071067811865428, -0.70710678118655224 }, { 0.999229036240723,
      0.039259815759065585 }, { -0.80901699437495067, 0.5877852522924687 }, {
      0.34611705707748996, -0.93819133592248527 }, { 0.15643446504022473,
      0.98768834059513866 }, { -0.55557023301960362, -0.83146961230254435 }, {
      0.80901699437494234, 0.58778525229248013 }, { -0.938191335922486,
      -0.34611705707748791 }, { 0.98768834059513677, 0.15643446504023659 }, { -
      0.99922903624072323, -0.039259815759061178 } };

  creal_T c2_tmp_data[1];
  creal_T c2_dcv1[1];
  int32_T c2_f_loop_ub;
  int32_T c2_i20;
  for (c2_i11 = 0; c2_i11 < 2; c2_i11++) {
    c2_OutputSampleIndex[c2_i11] = c2_obj->pOutputStartSampleIndex +
      c2_obj->pOutputSampleInterval[c2_i11];
  }

  for (c2_i12 = 0; c2_i12 < 2; c2_i12++) {
    c2_OutputSampleIndex[c2_i12]--;
  }

  for (c2_k = 0; c2_k < 2; c2_k++) {
    c2_b_k = 1.0 + (real_T)c2_k;
    c2_xk = c2_OutputSampleIndex[(int32_T)c2_b_k - 1];
    c2_x = c2_xk;
    c2_b_x = c2_x / 200.0;
    c2_c_x = c2_b_x;
    c2_c_x = muDoubleScalarFloor(c2_c_x);
    c2_r = c2_x - c2_c_x * 200.0;
    c2_b_r[(int32_T)c2_b_k - 1] = c2_r;
  }

  for (c2_i13 = 0; c2_i13 < 2; c2_i13++) {
    c2_OutputSampleIndex[c2_i13] = c2_b_r[c2_i13] + 1.0;
  }

  c2_b_obj = c2_obj;
  c2_value = c2_OutputSampleIndex[1];
  c2_b_obj->pOutputStartSampleIndex = c2_value;
  c2_y = c2_dc1;
  c2_b0 = (c2_OutputSampleIndex[0] >= 1.0);
  c2_b1 = (c2_OutputSampleIndex[0] <= 40.0);
  c2_d_x = (c2_b0 && c2_b1);
  c2_e_x = c2_d_x;
  if (c2_e_x) {
    c2_ii_sizes[0] = 1;
    c2_ii_sizes[1] = 1;
    c2_ii = c2_ii_sizes[0];
    c2_b_ii = c2_ii_sizes[1];
    c2_ii_data[0] = 1;
  } else {
    c2_ii_sizes[0] = 0;
    c2_ii_sizes[1] = 0;
    c2_c_ii = c2_ii_sizes[0];
    c2_d_ii = c2_ii_sizes[1];
  }

  c2_currentPulseIdx_sizes[0] = c2_ii_sizes[0];
  c2_currentPulseIdx_sizes[1] = c2_ii_sizes[1];
  c2_currentPulseIdx = c2_currentPulseIdx_sizes[0];
  c2_b_currentPulseIdx = c2_currentPulseIdx_sizes[1];
  c2_loop_ub = c2_ii_sizes[0] * c2_ii_sizes[1] - 1;
  for (c2_i14 = 0; c2_i14 <= c2_loop_ub; c2_i14++) {
    c2_currentPulseIdx_data[c2_i14] = (real_T)c2_ii_data[c2_i14];
  }

  c2_b2 = (c2_currentPulseIdx_sizes[0] == 0);
  c2_b3 = (c2_currentPulseIdx_sizes[1] == 0);
  if (!(c2_b2 || c2_b3)) {
    for (c2_i15 = 0; c2_i15 < 2; c2_i15++) {
      c2_iv0[c2_i15] = 1 + c2_i15;
    }

    sf_debug_matrix_matrix_index_check(c2_iv0, 2, c2_currentPulseIdx_sizes, 2);
    c2_sampleIdx_sizes[0] = c2_currentPulseIdx_sizes[0];
    c2_sampleIdx_sizes[1] = c2_currentPulseIdx_sizes[1];
    c2_sampleIdx = c2_sampleIdx_sizes[0];
    c2_b_sampleIdx = c2_sampleIdx_sizes[1];
    c2_b_loop_ub = c2_currentPulseIdx_sizes[0] * c2_currentPulseIdx_sizes[1] - 1;
    for (c2_i16 = 0; c2_i16 <= c2_b_loop_ub; c2_i16++) {
      c2_sampleIdx_data[c2_i16] = (c2_OutputSampleIndex[(int32_T)
        c2_currentPulseIdx_data[c2_i16] - 1] - 1.0) + 1.0;
    }

    c2_ii_sizes[0] = c2_currentPulseIdx_sizes[0];
    c2_ii_sizes[1] = c2_currentPulseIdx_sizes[1];
    c2_e_ii = c2_ii_sizes[0];
    c2_f_ii = c2_ii_sizes[1];
    c2_c_loop_ub = c2_currentPulseIdx_sizes[0] * c2_currentPulseIdx_sizes[1] - 1;
    for (c2_i17 = 0; c2_i17 <= c2_c_loop_ub; c2_i17++) {
      c2_ii_data[c2_i17] = (int32_T)c2_currentPulseIdx_data[c2_i17];
    }

    c2_currentPulseIdx_sizes[0] = c2_sampleIdx_sizes[0];
    c2_currentPulseIdx_sizes[1] = c2_sampleIdx_sizes[1];
    c2_c_currentPulseIdx = c2_currentPulseIdx_sizes[0];
    c2_d_currentPulseIdx = c2_currentPulseIdx_sizes[1];
    c2_d_loop_ub = c2_sampleIdx_sizes[0] * c2_sampleIdx_sizes[1] - 1;
    for (c2_i18 = 0; c2_i18 <= c2_d_loop_ub; c2_i18++) {
      c2_currentPulseIdx_data[c2_i18] = (real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("",
        (int32_T)_SFD_INTEGER_CHECK("", c2_sampleIdx_data[c2_i18]), 1, 40, 1, 0);
    }

    c2_c_sampleIdx[0] = c2_sampleIdx_sizes[0] * c2_sampleIdx_sizes[1];
    c2_tmp_sizes = c2_c_sampleIdx[0];
    c2_e_loop_ub = c2_c_sampleIdx[0] - 1;
    for (c2_i19 = 0; c2_i19 <= c2_e_loop_ub; c2_i19++) {
      c2_tmp_data[c2_i19] = c2_dcv0[(int32_T)c2_currentPulseIdx_data[c2_i19] - 1];
    }

    sf_debug_size_eq_check_1d(c2_ii_sizes[0] * c2_ii_sizes[1], c2_tmp_sizes);
    c2_dcv1[0] = c2_y;
    c2_f_loop_ub = c2_ii_sizes[0] * c2_ii_sizes[1] - 1;
    for (c2_i20 = 0; c2_i20 <= c2_f_loop_ub; c2_i20++) {
      c2_dcv1[c2_ii_data[c2_i20] - 1] = c2_tmp_data[c2_i20];
    }

    c2_y = c2_dcv1[0];
  }

  return c2_y;
}

static const mxArray *c2_d_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(int32_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static int32_T c2_d_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  int32_T c2_y;
  int32_T c2_i21;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_i21, 1, 6, 0U, 0, 0U, 0);
  c2_y = c2_i21;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_b_sfEvent;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  int32_T c2_y;
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)chartInstanceVoid;
  c2_b_sfEvent = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_b_sfEvent),
    &c2_thisId);
  sf_mex_destroy(&c2_b_sfEvent);
  *(int32_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

static uint8_T c2_e_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_RadarSystemLevel_lfm, const
  char_T *c2_identifier)
{
  uint8_T c2_y;
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_f_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c2_b_is_active_c2_RadarSystemLevel_lfm), &c2_thisId);
  sf_mex_destroy(&c2_b_is_active_c2_RadarSystemLevel_lfm);
  return c2_y;
}

static uint8_T c2_f_emlrt_marshallIn(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  uint8_T c2_y;
  uint8_T c2_u0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_u0, 1, 3, 0U, 0, 0U, 0);
  c2_y = c2_u0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void init_dsm_address_info(SFc2_RadarSystemLevel_lfmInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c2_RadarSystemLevel_lfm_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1061885101U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(4203099216U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1662236206U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(414994285U);
}

mxArray *sf_c2_RadarSystemLevel_lfm_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("8kVz1A97iCC0OYlJjawgLF");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
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

static const mxArray *sf_get_sim_state_info_c2_RadarSystemLevel_lfm(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"y\",},{M[8],M[0],T\"is_active_c2_RadarSystemLevel_lfm\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c2_RadarSystemLevel_lfm_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
    chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)
      ((ChartInfoStruct *)(ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_RadarSystemLevel_lfmMachineNumber_,
           2,
           1,
           1,
           1,
           0,
           0,
           0,
           0,
           1,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_RadarSystemLevel_lfmMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (_RadarSystemLevel_lfmMachineNumber_,chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds
            (_RadarSystemLevel_lfmMachineNumber_,
             chartInstance->chartNumber,
             0,
             0,
             0);
          _SFD_SET_DATA_PROPS(0,2,0,1,"y");
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
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,49);
        _SFD_CV_INIT_SCRIPT(0,1,1,0,0,0,0,0,0,0);
        _SFD_CV_INIT_SCRIPT_FCN(0,0,"waveform_lfm",0,-1,276);
        _SFD_CV_INIT_SCRIPT_IF(0,0,46,62,-1,259);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,1,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)c2_sf_marshallIn);

        {
          creal_T *c2_y;
          c2_y = (creal_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          _SFD_SET_DATA_VALUE_PTR(0U, c2_y);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration
        (_RadarSystemLevel_lfmMachineNumber_,chartInstance->chartNumber,
         chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization()
{
  return "6EutYW10g3X8MSa35Q42DF";
}

static void sf_opaque_initialize_c2_RadarSystemLevel_lfm(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc2_RadarSystemLevel_lfmInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c2_RadarSystemLevel_lfm
    ((SFc2_RadarSystemLevel_lfmInstanceStruct*) chartInstanceVar);
  initialize_c2_RadarSystemLevel_lfm((SFc2_RadarSystemLevel_lfmInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c2_RadarSystemLevel_lfm(void *chartInstanceVar)
{
  enable_c2_RadarSystemLevel_lfm((SFc2_RadarSystemLevel_lfmInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c2_RadarSystemLevel_lfm(void *chartInstanceVar)
{
  disable_c2_RadarSystemLevel_lfm((SFc2_RadarSystemLevel_lfmInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c2_RadarSystemLevel_lfm(void *chartInstanceVar)
{
  sf_c2_RadarSystemLevel_lfm((SFc2_RadarSystemLevel_lfmInstanceStruct*)
    chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c2_RadarSystemLevel_lfm
  (SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c2_RadarSystemLevel_lfm
    ((SFc2_RadarSystemLevel_lfmInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_RadarSystemLevel_lfm();/* state var info */
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

extern void sf_internal_set_sim_state_c2_RadarSystemLevel_lfm(SimStruct* S,
  const mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_RadarSystemLevel_lfm();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c2_RadarSystemLevel_lfm((SFc2_RadarSystemLevel_lfmInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c2_RadarSystemLevel_lfm(SimStruct*
  S)
{
  return sf_internal_get_sim_state_c2_RadarSystemLevel_lfm(S);
}

static void sf_opaque_set_sim_state_c2_RadarSystemLevel_lfm(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c2_RadarSystemLevel_lfm(S, st);
}

static void sf_opaque_terminate_c2_RadarSystemLevel_lfm(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc2_RadarSystemLevel_lfmInstanceStruct*) chartInstanceVar
      )->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c2_RadarSystemLevel_lfm((SFc2_RadarSystemLevel_lfmInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_RadarSystemLevel_lfm_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc2_RadarSystemLevel_lfm((SFc2_RadarSystemLevel_lfmInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c2_RadarSystemLevel_lfm(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c2_RadarSystemLevel_lfm
      ((SFc2_RadarSystemLevel_lfmInstanceStruct*)(((ChartInfoStruct *)
         ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c2_RadarSystemLevel_lfm(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_RadarSystemLevel_lfm_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      2);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,2,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,2,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,2,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,2);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(3430116924U));
  ssSetChecksum1(S,(1397374211U));
  ssSetChecksum2(S,(2778664419U));
  ssSetChecksum3(S,(468723898U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSetSimStateCompliance(S, DISALLOW_SIM_STATE);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c2_RadarSystemLevel_lfm(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c2_RadarSystemLevel_lfm(SimStruct *S)
{
  SFc2_RadarSystemLevel_lfmInstanceStruct *chartInstance;
  chartInstance = (SFc2_RadarSystemLevel_lfmInstanceStruct *)malloc(sizeof
    (SFc2_RadarSystemLevel_lfmInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc2_RadarSystemLevel_lfmInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.enableChart =
    sf_opaque_enable_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.disableChart =
    sf_opaque_disable_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.mdlStart = mdlStart_c2_RadarSystemLevel_lfm;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c2_RadarSystemLevel_lfm;
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

void c2_RadarSystemLevel_lfm_method_dispatcher(SimStruct *S, int_T method, void *
  data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c2_RadarSystemLevel_lfm(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c2_RadarSystemLevel_lfm(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c2_RadarSystemLevel_lfm(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c2_RadarSystemLevel_lfm_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
