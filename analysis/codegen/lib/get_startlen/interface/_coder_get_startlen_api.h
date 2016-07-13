/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_get_startlen_api.h
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 30-Nov-2015 14:22:03
 */

#ifndef ___CODER_GET_STARTLEN_API_H__
#define ___CODER_GET_STARTLEN_API_H__

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_get_startlen_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

#ifndef struct_emxArray_real_T_1x1
#define struct_emxArray_real_T_1x1

struct emxArray_real_T_1x1
{
  real_T data[1];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_1x1*/

#ifndef typedef_emxArray_real_T_1x1
#define typedef_emxArray_real_T_1x1

typedef struct emxArray_real_T_1x1 emxArray_real_T_1x1;

#endif                                 /*typedef_emxArray_real_T_1x1*/

#ifndef struct_emxArray_real_T_1x312
#define struct_emxArray_real_T_1x312

struct emxArray_real_T_1x312
{
  real_T data[312];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_1x312*/

#ifndef typedef_emxArray_real_T_1x312
#define typedef_emxArray_real_T_1x312

typedef struct emxArray_real_T_1x312 emxArray_real_T_1x312;

#endif                                 /*typedef_emxArray_real_T_1x312*/

#ifndef struct_emxArray_real_T_1x45
#define struct_emxArray_real_T_1x45

struct emxArray_real_T_1x45
{
  real_T data[45];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_1x45*/

#ifndef typedef_emxArray_real_T_1x45
#define typedef_emxArray_real_T_1x45

typedef struct emxArray_real_T_1x45 emxArray_real_T_1x45;

#endif                                 /*typedef_emxArray_real_T_1x45*/

#ifndef struct_emxArray_real_T_311x1
#define struct_emxArray_real_T_311x1

struct emxArray_real_T_311x1
{
  real_T data[311];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_311x1*/

#ifndef typedef_emxArray_real_T_311x1
#define typedef_emxArray_real_T_311x1

typedef struct emxArray_real_T_311x1 emxArray_real_T_311x1;

#endif                                 /*typedef_emxArray_real_T_311x1*/

#ifndef struct_emxArray_real_T_312x1
#define struct_emxArray_real_T_312x1

struct emxArray_real_T_312x1
{
  real_T data[312];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_312x1*/

#ifndef typedef_emxArray_real_T_312x1
#define typedef_emxArray_real_T_312x1

typedef struct emxArray_real_T_312x1 emxArray_real_T_312x1;

#endif                                 /*typedef_emxArray_real_T_312x1*/

#ifndef struct_emxArray_real_T_313x4
#define struct_emxArray_real_T_313x4

struct emxArray_real_T_313x4
{
  real_T data[1252];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_313x4*/

#ifndef typedef_emxArray_real_T_313x4
#define typedef_emxArray_real_T_313x4

typedef struct emxArray_real_T_313x4 emxArray_real_T_313x4;

#endif                                 /*typedef_emxArray_real_T_313x4*/

#ifndef struct_emxArray_uint16_T_1x9
#define struct_emxArray_uint16_T_1x9

struct emxArray_uint16_T_1x9
{
  uint16_T data[9];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_uint16_T_1x9*/

#ifndef typedef_emxArray_uint16_T_1x9
#define typedef_emxArray_uint16_T_1x9

typedef struct emxArray_uint16_T_1x9 emxArray_uint16_T_1x9;

#endif                                 /*typedef_emxArray_uint16_T_1x9*/

#ifndef typedef_struct3_T
#define typedef_struct3_T

typedef struct {
  real_T cellID;
  emxArray_real_T *Xcont;
  emxArray_real_T *Ycont;
  boolean_T on_edge;
  emxArray_uint16_T_1x9 proxID;
  emxArray_real_T_312x1 arc_length;
  emxArray_real_T_1x1 area;
  emxArray_real_T_1x1 pole1;
  emxArray_real_T_1x1 pole2;
  emxArray_real_T_1x312 kappa_raw;
  emxArray_real_T_312x1 kappa_smooth;
  emxArray_real_T_1x1 num_pts;
  emxArray_real_T_313x4 mesh;
  emxArray_real_T_1x1 cell_length;
  emxArray_real_T_1x1 cell_width;
  real_T roc;
  emxArray_real_T_311x1 fluor_interior;
  emxArray_real_T_1x1 ave_fluor;
  emxArray_real_T_312x1 fluor_profile;
  emxArray_real_T_311x1 cell_lengths;
} struct3_T;

#endif                                 /*typedef_struct3_T*/

#ifndef struct_emxArray_struct3_T
#define struct_emxArray_struct3_T

struct emxArray_struct3_T
{
  struct3_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_struct3_T*/

#ifndef typedef_emxArray_struct3_T
#define typedef_emxArray_struct3_T

typedef struct emxArray_struct3_T emxArray_struct3_T;

#endif                                 /*typedef_emxArray_struct3_T*/

#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  boolean_T linkq;
  char_T typeq[5];
  boolean_T growq;
  boolean_T writeq;
  boolean_T testq;
  boolean_T rejq;
  real_T f_areamin;
  real_T f_areamax;
  real_T f_hmin;
  real_T f_hmin_split;
  real_T f_gstd;
  real_T f_back;
  real_T f_histlim;
  real_T f_Nit;
  real_T f_r_int;
  real_T f_kint;
  real_T f_pert_same;
  real_T f_frame_diff;
  char_T outname[37];
} struct1_T;

#endif                                 /*typedef_struct1_T*/

#ifndef typedef_struct2_T
#define typedef_struct2_T

typedef struct {
  real_T num_cells;
  emxArray_struct3_T *object;
} struct2_T;

#endif                                 /*typedef_struct2_T*/

#ifndef typedef_struct4_T
#define typedef_struct4_T

typedef struct {
  emxArray_real_T_1x45 frames;
  emxArray_real_T_1x45 bw_label;
} struct4_T;

#endif                                 /*typedef_struct4_T*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  struct1_T param;
  struct2_T frame[45];
  struct4_T cell[559];
  char_T outname[173];
} struct0_T;

#endif                                 /*typedef_struct0_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void get_startlen(struct0_T *f, real_T c, real_T l_data[], int32_T
  l_size[2]);
extern void get_startlen_api(const mxArray * const prhs[2], const mxArray *plhs
  [1]);
extern void get_startlen_atexit(void);
extern void get_startlen_initialize(void);
extern void get_startlen_terminate(void);
extern void get_startlen_xil_terminate(void);

#endif

/*
 * File trailer for _coder_get_startlen_api.h
 *
 * [EOF]
 */
