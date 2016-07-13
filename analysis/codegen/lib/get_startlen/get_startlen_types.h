/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: get_startlen_types.h
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 30-Nov-2015 14:22:03
 */

#ifndef __GET_STARTLEN_TYPES_H__
#define __GET_STARTLEN_TYPES_H__

/* Include Files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  double *data;
  int *size;
  int allocatedSize;
  int numDimensions;
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
  double data[1];
  int size[2];
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
  double data[312];
  int size[2];
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
  double data[45];
  int size[2];
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
  double data[311];
  int size[2];
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
  double data[312];
  int size[2];
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
  double data[1252];
  int size[2];
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
  unsigned short data[9];
  int size[2];
};

#endif                                 /*struct_emxArray_uint16_T_1x9*/

#ifndef typedef_emxArray_uint16_T_1x9
#define typedef_emxArray_uint16_T_1x9

typedef struct emxArray_uint16_T_1x9 emxArray_uint16_T_1x9;

#endif                                 /*typedef_emxArray_uint16_T_1x9*/

#ifndef typedef_struct3_T
#define typedef_struct3_T

typedef struct {
  double cellID;
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
  double roc;
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
  int *size;
  int allocatedSize;
  int numDimensions;
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
  char typeq[5];
  boolean_T growq;
  boolean_T writeq;
  boolean_T testq;
  boolean_T rejq;
  double f_areamin;
  double f_areamax;
  double f_hmin;
  double f_hmin_split;
  double f_gstd;
  double f_back;
  double f_histlim;
  double f_Nit;
  double f_r_int;
  double f_kint;
  double f_pert_same;
  double f_frame_diff;
  char outname[37];
} struct1_T;

#endif                                 /*typedef_struct1_T*/

#ifndef typedef_struct2_T
#define typedef_struct2_T

typedef struct {
  double num_cells;
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
  char outname[173];
} struct0_T;

#endif                                 /*typedef_struct0_T*/
#endif

/*
 * File trailer for get_startlen_types.h
 *
 * [EOF]
 */
