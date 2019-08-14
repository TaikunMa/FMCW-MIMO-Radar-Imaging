/* Include files */

#include "RadarSystemLevel_3_sfun.h"
#include "RadarSystemLevel_3_sfun_debug_macros.h"
#include "c1_RadarSystemLevel_3.h"
#include "c2_RadarSystemLevel_3.h"
#include "c3_RadarSystemLevel_3.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
uint32_T _RadarSystemLevel_3MachineNumber_;
real_T _sfTime_;

/* Function Declarations */

/* Function Definitions */
void RadarSystemLevel_3_initializer(void)
{
}

void RadarSystemLevel_3_terminator(void)
{
}

/* SFunction Glue Code */
unsigned int sf_RadarSystemLevel_3_method_dispatcher(SimStruct *simstructPtr,
  unsigned int chartFileNumber, const char* specsCksum, int_T method, void *data)
{
  if (chartFileNumber==1) {
    c1_RadarSystemLevel_3_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==2) {
    c2_RadarSystemLevel_3_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==3) {
    c3_RadarSystemLevel_3_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  return 0;
}

unsigned int sf_RadarSystemLevel_3_process_check_sum_call( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the checksum */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"sf_get_check_sum"))
    return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if (nrhs>1 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if (!strcmp(commandName,"machine")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1278953969U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3515496549U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2555818983U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(553207121U);
    } else if (!strcmp(commandName,"exportedFcn")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0U);
    } else if (!strcmp(commandName,"makefile")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3434297083U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(4250980271U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1092462507U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3914086882U);
    } else if (nrhs==3 && !strcmp(commandName,"chart")) {
      unsigned int chartFileNumber;
      chartFileNumber = (unsigned int)mxGetScalar(prhs[2]);
      switch (chartFileNumber) {
       case 1:
        {
          extern void sf_c1_RadarSystemLevel_3_get_check_sum(mxArray *plhs[]);
          sf_c1_RadarSystemLevel_3_get_check_sum(plhs);
          break;
        }

       case 2:
        {
          extern void sf_c2_RadarSystemLevel_3_get_check_sum(mxArray *plhs[]);
          sf_c2_RadarSystemLevel_3_get_check_sum(plhs);
          break;
        }

       case 3:
        {
          extern void sf_c3_RadarSystemLevel_3_get_check_sum(mxArray *plhs[]);
          sf_c3_RadarSystemLevel_3_get_check_sum(plhs);
          break;
        }

       default:
        ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
      }
    } else if (!strcmp(commandName,"target")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3564696471U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(678668628U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1090454852U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3896867807U);
    } else {
      return 0;
    }
  } else {
    ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3212507239U);
    ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(4278999261U);
    ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3446917991U);
    ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3366370099U);
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_RadarSystemLevel_3_autoinheritance_info( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[32];
  char aiChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the autoinheritance_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_autoinheritance_info"))
    return 0;
  mxGetString(prhs[2], aiChksum,sizeof(aiChksum)/sizeof(char));
  aiChksum[(sizeof(aiChksum)/sizeof(char)-1)] = '\0';

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(aiChksum, "UchVpMlPdeBr9NaMKNxxrF") == 0) {
          extern mxArray *sf_c1_RadarSystemLevel_3_get_autoinheritance_info(void);
          plhs[0] = sf_c1_RadarSystemLevel_3_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 2:
      {
        if (strcmp(aiChksum, "0SNwZ4NVpzOq0T3cFH3U4G") == 0) {
          extern mxArray *sf_c2_RadarSystemLevel_3_get_autoinheritance_info(void);
          plhs[0] = sf_c2_RadarSystemLevel_3_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 3:
      {
        if (strcmp(aiChksum, "xtCYd73lUTB5BBVIFJTzjC") == 0) {
          extern mxArray *sf_c3_RadarSystemLevel_3_get_autoinheritance_info(void);
          plhs[0] = sf_c3_RadarSystemLevel_3_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_RadarSystemLevel_3_get_eml_resolved_functions_info( int nlhs,
  mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[64];
  if (nrhs<2 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the get_eml_resolved_functions_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_eml_resolved_functions_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        extern const mxArray
          *sf_c1_RadarSystemLevel_3_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c1_RadarSystemLevel_3_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 2:
      {
        extern const mxArray
          *sf_c2_RadarSystemLevel_3_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c2_RadarSystemLevel_3_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 3:
      {
        extern const mxArray
          *sf_c3_RadarSystemLevel_3_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c3_RadarSystemLevel_3_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_RadarSystemLevel_3_third_party_uses_info( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the third_party_uses_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_third_party_uses_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "ZR5tr7wvvYLTKmUFIqh1QF") == 0) {
          extern mxArray *sf_c1_RadarSystemLevel_3_third_party_uses_info(void);
          plhs[0] = sf_c1_RadarSystemLevel_3_third_party_uses_info();
          break;
        }
      }

     case 2:
      {
        if (strcmp(tpChksum, "6EutYW10g3X8MSa35Q42DF") == 0) {
          extern mxArray *sf_c2_RadarSystemLevel_3_third_party_uses_info(void);
          plhs[0] = sf_c2_RadarSystemLevel_3_third_party_uses_info();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "ZyLjUOOBtoM7TsZJtTsVL") == 0) {
          extern mxArray *sf_c3_RadarSystemLevel_3_third_party_uses_info(void);
          plhs[0] = sf_c3_RadarSystemLevel_3_third_party_uses_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

void RadarSystemLevel_3_debug_initialize(struct SfDebugInstanceStruct*
  debugInstance)
{
  _RadarSystemLevel_3MachineNumber_ = sf_debug_initialize_machine(debugInstance,
    "RadarSystemLevel_3","sfun",0,3,0,0,0);
  sf_debug_set_machine_event_thresholds(debugInstance,
    _RadarSystemLevel_3MachineNumber_,0,0);
  sf_debug_set_machine_data_thresholds(debugInstance,
    _RadarSystemLevel_3MachineNumber_,0);
}

void RadarSystemLevel_3_register_exported_symbols(SimStruct* S)
{
}

static mxArray* sRtwOptimizationInfoStruct= NULL;
mxArray* load_RadarSystemLevel_3_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct==NULL) {
    sRtwOptimizationInfoStruct = sf_load_rtw_optimization_info(
      "RadarSystemLevel_3", "RadarSystemLevel_3");
    mexMakeArrayPersistent(sRtwOptimizationInfoStruct);
  }

  return(sRtwOptimizationInfoStruct);
}

void unload_RadarSystemLevel_3_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct!=NULL) {
    mxDestroyArray(sRtwOptimizationInfoStruct);
    sRtwOptimizationInfoStruct = NULL;
  }
}
