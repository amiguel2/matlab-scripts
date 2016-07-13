/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_get_startlen_api.c
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 30-Nov-2015 14:22:03
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_get_startlen_api.h"

/* Type Definitions */
#ifndef struct_emxArray__common
#define struct_emxArray__common

struct emxArray__common
{
  void *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray__common*/

#ifndef typedef_emxArray__common
#define typedef_emxArray__common

typedef struct emxArray__common emxArray__common;

#endif                                 /*typedef_emxArray__common*/

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true, false, 131418U, NULL, "get_startlen",
  NULL, false, { 2045744189U, 2170104910U, 2743257031U, 4284093946U }, NULL };

/* Function Declarations */
static void ab_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, uint16_T ret_data[], int32_T ret_size[2]);
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y);
static void bb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2]);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct1_T *y);
static void cb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2]);
static boolean_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId);
static void db_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2]);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[5]);
static void eb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2]);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *f, const
  char_T *identifier, struct0_T *y);
static const mxArray *emlrt_marshallOut(const real_T u_data[], const int32_T
  u_size[2]);
static void emxEnsureCapacity(emxArray__common *emxArray, int32_T oldNumel,
  int32_T elementSize);
static void emxEnsureCapacity_struct3_T(const emlrtStack *sp, emxArray_struct3_T
  *emxArray, int32_T oldNumel);
static void emxExpand_struct3_T(const emlrtStack *sp, emxArray_struct3_T
  *emxArray, int32_T fromIndex, int32_T toIndex);
static void emxFreeMatrix_struct2_T(struct2_T pMatrix[45]);
static void emxFreeMatrix_struct4_T(void);
static void emxFreeStruct_struct0_T(struct0_T *pStruct);
static void emxFreeStruct_struct2_T(struct2_T *pStruct);
static void emxFreeStruct_struct3_T(struct3_T *pStruct);
static void emxFree_real_T(emxArray_real_T **pEmxArray);
static void emxFree_struct3_T(emxArray_struct3_T **pEmxArray);
static void emxInitMatrix_struct2_T(const emlrtStack *sp, struct2_T pMatrix[45],
  boolean_T doPush);
static void emxInitMatrix_struct4_T(struct4_T pMatrix[559]);
static void emxInitStruct_struct0_T(const emlrtStack *sp, struct0_T *pStruct,
  boolean_T doPush);
static void emxInitStruct_struct2_T(const emlrtStack *sp, struct2_T *pStruct,
  boolean_T doPush);
static void emxInitStruct_struct3_T(const emlrtStack *sp, struct3_T *pStruct,
  boolean_T doPush);
static void emxInitStruct_struct4_T(struct4_T *pStruct);
static void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray,
  int32_T numDimensions, boolean_T doPush);
static void emxInit_struct3_T(const emlrtStack *sp, emxArray_struct3_T
  **pEmxArray, int32_T numDimensions, boolean_T doPush);
static void emxTrim_struct3_T(emxArray_struct3_T *emxArray, int32_T fromIndex,
  int32_T toIndex);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void fb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2]);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[37]);
static void gb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2]);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct2_T y[45]);
static void hb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[173]);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_struct3_T *y);
static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, uint16_T y_data[], int32_T y_size[2]);
static void l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2]);
static void m_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2]);
static void n_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2]);
static void o_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2]);
static void p_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2]);
static void q_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct4_T y[559]);
static void r_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2]);
static void s_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[173]);
static real_T t_emlrt_marshallIn(const emlrtStack *sp, const mxArray *c, const
  char_T *identifier);
static boolean_T u_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId);
static void v_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[5]);
static real_T w_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static void x_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[37]);
static void y_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);

/* Function Definitions */

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                uint16_T ret_data[]
 *                int32_T ret_size[2]
 * Return Type  : void
 */
static void ab_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, uint16_T ret_data[], int32_T ret_size[2])
{
  int32_T iv8[2];
  int32_T i6;
  int32_T iv9[2];
  boolean_T bv2[2] = { false, true };

  for (i6 = 0; i6 < 2; i6++) {
    iv8[i6] = 1 + (i6 << 3);
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "uint16", false, 2U, iv8, &bv2[0],
    iv9);
  ret_size[0] = iv9[0];
  ret_size[1] = iv9[1];
  emlrtImportArrayR2011b(src, (void *)ret_data, 2, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                struct0_T *y
 * Return Type  : void
 */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y)
{
  emlrtMsgIdentifier thisId;
  static const char * fieldNames[4] = { "param", "frame", "cell", "outname" };

  thisId.fParent = parentId;
  emlrtCheckStructR2012b(sp, parentId, u, 4, fieldNames, 0U, 0);
  thisId.fIdentifier = "param";
  c_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "param")),
                     &thisId, &y->param);
  thisId.fIdentifier = "frame";
  h_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "frame")),
                     &thisId, y->frame);
  thisId.fIdentifier = "cell";
  q_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "cell")),
                     &thisId, y->cell);
  thisId.fIdentifier = "outname";
  s_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "outname")),
                     &thisId, y->outname);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                real_T ret_data[]
 *                int32_T ret_size[2]
 * Return Type  : void
 */
static void bb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2])
{
  int32_T iv10[2];
  int32_T i7;
  int32_T iv11[2];
  boolean_T bv3[2] = { true, true };

  for (i7 = 0; i7 < 2; i7++) {
    iv10[i7] = 312 + -311 * i7;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv10, &bv3[0],
    iv11);
  ret_size[0] = iv11[0];
  ret_size[1] = iv11[1];
  emlrtImportArrayR2011b(src, (void *)ret_data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                struct1_T *y
 * Return Type  : void
 */
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct1_T *y)
{
  emlrtMsgIdentifier thisId;
  static const char * fieldNames[19] = { "linkq", "typeq", "growq", "writeq",
    "testq", "rejq", "f_areamin", "f_areamax", "f_hmin", "f_hmin_split",
    "f_gstd", "f_back", "f_histlim", "f_Nit", "f_r_int", "f_kint", "f_pert_same",
    "f_frame_diff", "outname" };

  thisId.fParent = parentId;
  emlrtCheckStructR2012b(sp, parentId, u, 19, fieldNames, 0U, 0);
  thisId.fIdentifier = "linkq";
  y->linkq = d_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "linkq")), &thisId);
  thisId.fIdentifier = "typeq";
  e_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "typeq")),
                     &thisId, y->typeq);
  thisId.fIdentifier = "growq";
  y->growq = d_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "growq")), &thisId);
  thisId.fIdentifier = "writeq";
  y->writeq = d_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "writeq")), &thisId);
  thisId.fIdentifier = "testq";
  y->testq = d_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "testq")), &thisId);
  thisId.fIdentifier = "rejq";
  y->rejq = d_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "rejq")), &thisId);
  thisId.fIdentifier = "f_areamin";
  y->f_areamin = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_areamin")), &thisId);
  thisId.fIdentifier = "f_areamax";
  y->f_areamax = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_areamax")), &thisId);
  thisId.fIdentifier = "f_hmin";
  y->f_hmin = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_hmin")), &thisId);
  thisId.fIdentifier = "f_hmin_split";
  y->f_hmin_split = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u,
    0, "f_hmin_split")), &thisId);
  thisId.fIdentifier = "f_gstd";
  y->f_gstd = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_gstd")), &thisId);
  thisId.fIdentifier = "f_back";
  y->f_back = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_back")), &thisId);
  thisId.fIdentifier = "f_histlim";
  y->f_histlim = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_histlim")), &thisId);
  thisId.fIdentifier = "f_Nit";
  y->f_Nit = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_Nit")), &thisId);
  thisId.fIdentifier = "f_r_int";
  y->f_r_int = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_r_int")), &thisId);
  thisId.fIdentifier = "f_kint";
  y->f_kint = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0,
    "f_kint")), &thisId);
  thisId.fIdentifier = "f_pert_same";
  y->f_pert_same = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u,
    0, "f_pert_same")), &thisId);
  thisId.fIdentifier = "f_frame_diff";
  y->f_frame_diff = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u,
    0, "f_frame_diff")), &thisId);
  thisId.fIdentifier = "outname";
  g_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "outname")),
                     &thisId, y->outname);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                real_T ret_data[]
 *                int32_T ret_size[2]
 * Return Type  : void
 */
static void cb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2])
{
  int32_T iv12[2];
  int32_T i;
  int32_T iv13[2];
  boolean_T bv4[2] = { true, true };

  for (i = 0; i < 2; i++) {
    iv12[i] = 1;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv12, &bv4[0],
    iv13);
  ret_size[0] = iv13[0];
  ret_size[1] = iv13[1];
  emlrtImportArrayR2011b(src, (void *)ret_data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : boolean_T
 */
static boolean_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId)
{
  boolean_T y;
  y = u_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                real_T ret_data[]
 *                int32_T ret_size[2]
 * Return Type  : void
 */
static void db_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2])
{
  int32_T iv14[2];
  int32_T i8;
  int32_T iv15[2];
  boolean_T bv5[2] = { true, true };

  for (i8 = 0; i8 < 2; i8++) {
    iv14[i8] = 1 + 311 * i8;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv14, &bv5[0],
    iv15);
  ret_size[0] = iv15[0];
  ret_size[1] = iv15[1];
  emlrtImportArrayR2011b(src, (void *)ret_data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                char_T y[5]
 * Return Type  : void
 */
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[5])
{
  v_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                real_T ret_data[]
 *                int32_T ret_size[2]
 * Return Type  : void
 */
static void eb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2])
{
  int32_T iv16[2];
  int32_T i9;
  int32_T iv17[2];
  boolean_T bv6[2] = { true, true };

  for (i9 = 0; i9 < 2; i9++) {
    iv16[i9] = 313 + -309 * i9;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv16, &bv6[0],
    iv17);
  ret_size[0] = iv17[0];
  ret_size[1] = iv17[1];
  emlrtImportArrayR2011b(src, (void *)ret_data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *f
 *                const char_T *identifier
 *                struct0_T *y
 * Return Type  : void
 */
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *f, const
  char_T *identifier, struct0_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  b_emlrt_marshallIn(sp, emlrtAlias(f), &thisId, y);
  emlrtDestroyArray(&f);
}

/*
 * Arguments    : const real_T u_data[]
 *                const int32_T u_size[2]
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const real_T u_data[], const int32_T
  u_size[2])
{
  const mxArray *y;
  static const int32_T iv3[2] = { 0, 0 };

  const mxArray *m0;
  y = NULL;
  m0 = emlrtCreateNumericArray(2, iv3, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m0, (void *)u_data);
  emlrtSetDimensions((mxArray *)m0, u_size, 2);
  emlrtAssign(&y, m0);
  return y;
}

/*
 * Arguments    : emxArray__common *emxArray
 *                int32_T oldNumel
 *                int32_T elementSize
 * Return Type  : void
 */
static void emxEnsureCapacity(emxArray__common *emxArray, int32_T oldNumel,
  int32_T elementSize)
{
  int32_T newNumel;
  int32_T i;
  void *newData;
  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      i <<= 1;
    }

    newData = emlrtCallocMex((uint32_T)i, (uint32_T)elementSize);
    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, (uint32_T)(elementSize * oldNumel));
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }

    emxArray->data = newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

/*
 * Arguments    : const emlrtStack *sp
 *                emxArray_struct3_T *emxArray
 *                int32_T oldNumel
 * Return Type  : void
 */
static void emxEnsureCapacity_struct3_T(const emlrtStack *sp, emxArray_struct3_T
  *emxArray, int32_T oldNumel)
{
  int32_T elementSize;
  int32_T newNumel;
  int32_T i;
  void *newData;
  elementSize = (int32_T)sizeof(struct3_T);
  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      i <<= 1;
    }

    newData = emlrtCallocMex((uint32_T)i, (uint32_T)elementSize);
    if (emxArray->data != NULL) {
      memcpy(newData, (void *)emxArray->data, (uint32_T)(elementSize * oldNumel));
      if (emxArray->canFreeData) {
        emlrtFreeMex((void *)emxArray->data);
      }
    }

    emxArray->data = (struct3_T *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }

  if (oldNumel > newNumel) {
    emxTrim_struct3_T(emxArray, newNumel, oldNumel);
  } else {
    if (oldNumel < newNumel) {
      emxExpand_struct3_T(sp, emxArray, oldNumel, newNumel);
    }
  }
}

/*
 * Arguments    : const emlrtStack *sp
 *                emxArray_struct3_T *emxArray
 *                int32_T fromIndex
 *                int32_T toIndex
 * Return Type  : void
 */
static void emxExpand_struct3_T(const emlrtStack *sp, emxArray_struct3_T
  *emxArray, int32_T fromIndex, int32_T toIndex)
{
  int32_T i;
  for (i = fromIndex; i < toIndex; i++) {
    emxInitStruct_struct3_T(sp, &emxArray->data[i], false);
  }
}

/*
 * Arguments    : struct2_T pMatrix[45]
 * Return Type  : void
 */
static void emxFreeMatrix_struct2_T(struct2_T pMatrix[45])
{
  int32_T i;
  for (i = 0; i < 45; i++) {
    emxFreeStruct_struct2_T(&pMatrix[i]);
  }
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void emxFreeMatrix_struct4_T(void)
{
}

/*
 * Arguments    : struct0_T *pStruct
 * Return Type  : void
 */
static void emxFreeStruct_struct0_T(struct0_T *pStruct)
{
  emxFreeMatrix_struct2_T(pStruct->frame);
  emxFreeMatrix_struct4_T();
}

/*
 * Arguments    : struct2_T *pStruct
 * Return Type  : void
 */
static void emxFreeStruct_struct2_T(struct2_T *pStruct)
{
  emxFree_struct3_T(&pStruct->object);
}

/*
 * Arguments    : struct3_T *pStruct
 * Return Type  : void
 */
static void emxFreeStruct_struct3_T(struct3_T *pStruct)
{
  emxFree_real_T(&pStruct->Xcont);
  emxFree_real_T(&pStruct->Ycont);
}

/*
 * Arguments    : emxArray_real_T **pEmxArray
 * Return Type  : void
 */
static void emxFree_real_T(emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (real_T *)NULL) && (*pEmxArray)->canFreeData) {
      emlrtFreeMex((void *)(*pEmxArray)->data);
    }

    emlrtFreeMex((void *)(*pEmxArray)->size);
    emlrtFreeMex((void *)*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

/*
 * Arguments    : emxArray_struct3_T **pEmxArray
 * Return Type  : void
 */
static void emxFree_struct3_T(emxArray_struct3_T **pEmxArray)
{
  int32_T numEl;
  int32_T i;
  if (*pEmxArray != (emxArray_struct3_T *)NULL) {
    if ((*pEmxArray)->data != (struct3_T *)NULL) {
      numEl = 1;
      for (i = 0; i < (*pEmxArray)->numDimensions; i++) {
        numEl *= (*pEmxArray)->size[i];
      }

      for (i = 0; i < numEl; i++) {
        emxFreeStruct_struct3_T(&(*pEmxArray)->data[i]);
      }

      if ((*pEmxArray)->canFreeData) {
        emlrtFreeMex((void *)(*pEmxArray)->data);
      }
    }

    emlrtFreeMex((void *)(*pEmxArray)->size);
    emlrtFreeMex((void *)*pEmxArray);
    *pEmxArray = (emxArray_struct3_T *)NULL;
  }
}

/*
 * Arguments    : const emlrtStack *sp
 *                struct2_T pMatrix[45]
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInitMatrix_struct2_T(const emlrtStack *sp, struct2_T pMatrix[45],
  boolean_T doPush)
{
  int32_T i;
  for (i = 0; i < 45; i++) {
    emxInitStruct_struct2_T(sp, &pMatrix[i], doPush);
  }
}

/*
 * Arguments    : struct4_T pMatrix[559]
 * Return Type  : void
 */
static void emxInitMatrix_struct4_T(struct4_T pMatrix[559])
{
  int32_T i;
  for (i = 0; i < 559; i++) {
    emxInitStruct_struct4_T(&pMatrix[i]);
  }
}

/*
 * Arguments    : const emlrtStack *sp
 *                struct0_T *pStruct
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInitStruct_struct0_T(const emlrtStack *sp, struct0_T *pStruct,
  boolean_T doPush)
{
  emxInitMatrix_struct2_T(sp, pStruct->frame, doPush);
  emxInitMatrix_struct4_T(pStruct->cell);
}

/*
 * Arguments    : const emlrtStack *sp
 *                struct2_T *pStruct
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInitStruct_struct2_T(const emlrtStack *sp, struct2_T *pStruct,
  boolean_T doPush)
{
  emxInit_struct3_T(sp, &pStruct->object, 2, doPush);
}

/*
 * Arguments    : const emlrtStack *sp
 *                struct3_T *pStruct
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInitStruct_struct3_T(const emlrtStack *sp, struct3_T *pStruct,
  boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->Xcont, 2, doPush);
  emxInit_real_T(sp, &pStruct->Ycont, 2, doPush);
  pStruct->proxID.size[0] = 0;
  pStruct->proxID.size[1] = 0;
  pStruct->arc_length.size[0] = 0;
  pStruct->arc_length.size[1] = 0;
  pStruct->area.size[0] = 0;
  pStruct->area.size[1] = 0;
  pStruct->pole1.size[0] = 0;
  pStruct->pole1.size[1] = 0;
  pStruct->pole2.size[0] = 0;
  pStruct->pole2.size[1] = 0;
  pStruct->kappa_raw.size[0] = 0;
  pStruct->kappa_raw.size[1] = 0;
  pStruct->kappa_smooth.size[0] = 0;
  pStruct->kappa_smooth.size[1] = 0;
  pStruct->num_pts.size[0] = 0;
  pStruct->num_pts.size[1] = 0;
  pStruct->mesh.size[0] = 0;
  pStruct->mesh.size[1] = 0;
  pStruct->cell_length.size[0] = 0;
  pStruct->cell_length.size[1] = 0;
  pStruct->cell_width.size[0] = 0;
  pStruct->cell_width.size[1] = 0;
  pStruct->fluor_interior.size[0] = 0;
  pStruct->fluor_interior.size[1] = 0;
  pStruct->ave_fluor.size[0] = 0;
  pStruct->ave_fluor.size[1] = 0;
  pStruct->fluor_profile.size[0] = 0;
  pStruct->fluor_profile.size[1] = 0;
  pStruct->cell_lengths.size[0] = 0;
  pStruct->cell_lengths.size[1] = 0;
}

/*
 * Arguments    : struct4_T *pStruct
 * Return Type  : void
 */
static void emxInitStruct_struct4_T(struct4_T *pStruct)
{
  pStruct->frames.size[0] = 0;
  pStruct->frames.size[1] = 0;
  pStruct->bw_label.size[0] = 0;
  pStruct->bw_label.size[1] = 0;
}

/*
 * Arguments    : const emlrtStack *sp
 *                emxArray_real_T **pEmxArray
 *                int32_T numDimensions
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray,
  int32_T numDimensions, boolean_T doPush)
{
  emxArray_real_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_real_T *)emlrtMallocMex(sizeof(emxArray_real_T));
  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(sp, (void *)pEmxArray, (void (*)(void *))
      emxFree_real_T);
  }

  emxArray = *pEmxArray;
  emxArray->data = (real_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex((uint32_T)(sizeof(int32_T)
    * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/*
 * Arguments    : const emlrtStack *sp
 *                emxArray_struct3_T **pEmxArray
 *                int32_T numDimensions
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInit_struct3_T(const emlrtStack *sp, emxArray_struct3_T
  **pEmxArray, int32_T numDimensions, boolean_T doPush)
{
  emxArray_struct3_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_struct3_T *)emlrtMallocMex(sizeof(emxArray_struct3_T));
  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(sp, (void *)pEmxArray, (void (*)(void *))
      emxFree_struct3_T);
  }

  emxArray = *pEmxArray;
  emxArray->data = (struct3_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex((uint32_T)(sizeof(int32_T)
    * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/*
 * Arguments    : emxArray_struct3_T *emxArray
 *                int32_T fromIndex
 *                int32_T toIndex
 * Return Type  : void
 */
static void emxTrim_struct3_T(emxArray_struct3_T *emxArray, int32_T fromIndex,
  int32_T toIndex)
{
  int32_T i;
  for (i = fromIndex; i < toIndex; i++) {
    emxFreeStruct_struct3_T(&emxArray->data[i]);
  }
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T
 */
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = w_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                real_T ret_data[]
 *                int32_T ret_size[2]
 * Return Type  : void
 */
static void fb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2])
{
  int32_T iv18[2];
  int32_T i10;
  int32_T iv19[2];
  boolean_T bv7[2] = { true, true };

  for (i10 = 0; i10 < 2; i10++) {
    iv18[i10] = 311 + -310 * i10;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv18, &bv7[0],
    iv19);
  ret_size[0] = iv19[0];
  ret_size[1] = iv19[1];
  emlrtImportArrayR2011b(src, (void *)ret_data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                char_T y[37]
 * Return Type  : void
 */
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[37])
{
  x_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                real_T ret_data[]
 *                int32_T ret_size[2]
 * Return Type  : void
 */
static void gb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2])
{
  int32_T iv20[2];
  int32_T i11;
  int32_T iv21[2];
  boolean_T bv8[2] = { false, true };

  for (i11 = 0; i11 < 2; i11++) {
    iv20[i11] = 1 + 44 * i11;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv20, &bv8[0],
    iv21);
  ret_size[0] = iv21[0];
  ret_size[1] = iv21[1];
  emlrtImportArrayR2011b(src, (void *)ret_data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                struct2_T y[45]
 * Return Type  : void
 */
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct2_T y[45])
{
  emlrtMsgIdentifier thisId;
  int32_T iv0[2];
  int32_T i0;
  static const char * fieldNames[2] = { "num_cells", "object" };

  thisId.fParent = parentId;
  for (i0 = 0; i0 < 2; i0++) {
    iv0[i0] = 1 + 44 * i0;
  }

  emlrtCheckStructR2012b(sp, parentId, u, 2, fieldNames, 2U, iv0);
  for (i0 = 0; i0 < 45; i0++) {
    thisId.fIdentifier = "num_cells";
    y[i0].num_cells = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp,
      u, i0, "num_cells")), &thisId);
    thisId.fIdentifier = "object";
    i_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i0, "object")),
                       &thisId, y[i0].object);
  }

  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                char_T ret[173]
 * Return Type  : void
 */
static void hb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[173])
{
  int32_T iv22[2];
  int32_T i12;
  for (i12 = 0; i12 < 2; i12++) {
    iv22[i12] = 1 + 172 * i12;
  }

  emlrtCheckBuiltInR2012b(sp, msgId, src, "char", false, 2U, iv22);
  emlrtImportCharArrayR2014b(sp, src, ret, 173);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                emxArray_struct3_T *y
 * Return Type  : void
 */
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_struct3_T *y)
{
  emlrtMsgIdentifier thisId;
  int32_T iv1[2];
  int32_T i1;
  int32_T sizes[2];
  boolean_T bv0[2] = { false, true };

  static const char * fieldNames[20] = { "cellID", "Xcont", "Ycont", "on_edge",
    "proxID", "arc_length", "area", "pole1", "pole2", "kappa_raw",
    "kappa_smooth", "num_pts", "mesh", "cell_length", "cell_width", "roc",
    "fluor_interior", "ave_fluor", "fluor_profile", "cell_lengths" };

  int32_T n;
  thisId.fParent = parentId;
  for (i1 = 0; i1 < 2; i1++) {
    iv1[i1] = 1 + 134 * i1;
  }

  emlrtCheckVsStructR2012b(sp, parentId, u, 20, fieldNames, 2U, iv1, &bv0[0],
    sizes);
  i1 = y->size[0] * y->size[1];
  y->size[0] = sizes[0];
  y->size[1] = sizes[1];
  emxEnsureCapacity_struct3_T(sp, y, i1);
  n = y->size[1];
  for (i1 = 0; i1 < n; i1++) {
    thisId.fIdentifier = "cellID";
    y->data[i1].cellID = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a
      (sp, u, i1, "cellID")), &thisId);
    thisId.fIdentifier = "Xcont";
    j_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "Xcont")),
                       &thisId, y->data[i1].Xcont);
    thisId.fIdentifier = "Ycont";
    j_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "Ycont")),
                       &thisId, y->data[i1].Ycont);
    thisId.fIdentifier = "on_edge";
    y->data[i1].on_edge = d_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a
      (sp, u, i1, "on_edge")), &thisId);
    thisId.fIdentifier = "proxID";
    k_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "proxID")),
                       &thisId, y->data[i1].proxID.data, y->data[i1].proxID.size);
    thisId.fIdentifier = "arc_length";
    l_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1,
      "arc_length")), &thisId, y->data[i1].arc_length.data, y->data[i1].
                       arc_length.size);
    thisId.fIdentifier = "area";
    m_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "area")),
                       &thisId, y->data[i1].area.data, y->data[i1].area.size);
    thisId.fIdentifier = "pole1";
    m_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "pole1")),
                       &thisId, y->data[i1].pole1.data, y->data[i1].pole1.size);
    thisId.fIdentifier = "pole2";
    m_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "pole2")),
                       &thisId, y->data[i1].pole2.data, y->data[i1].pole2.size);
    thisId.fIdentifier = "kappa_raw";
    n_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "kappa_raw")),
                       &thisId, y->data[i1].kappa_raw.data, y->data[i1].
                       kappa_raw.size);
    thisId.fIdentifier = "kappa_smooth";
    l_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1,
      "kappa_smooth")), &thisId, y->data[i1].kappa_smooth.data, y->data[i1].
                       kappa_smooth.size);
    thisId.fIdentifier = "num_pts";
    m_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "num_pts")),
                       &thisId, y->data[i1].num_pts.data, y->data[i1].
                       num_pts.size);
    thisId.fIdentifier = "mesh";
    o_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "mesh")),
                       &thisId, y->data[i1].mesh.data, y->data[i1].mesh.size);
    thisId.fIdentifier = "cell_length";
    m_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1,
      "cell_length")), &thisId, y->data[i1].cell_length.data, y->data[i1].
                       cell_length.size);
    thisId.fIdentifier = "cell_width";
    m_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1,
      "cell_width")), &thisId, y->data[i1].cell_width.data, y->data[i1].
                       cell_width.size);
    thisId.fIdentifier = "roc";
    y->data[i1].roc = f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp,
      u, i1, "roc")), &thisId);
    thisId.fIdentifier = "fluor_interior";
    p_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1,
      "fluor_interior")), &thisId, y->data[i1].fluor_interior.data, y->data[i1].
                       fluor_interior.size);
    thisId.fIdentifier = "ave_fluor";
    m_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1, "ave_fluor")),
                       &thisId, y->data[i1].ave_fluor.data, y->data[i1].
                       ave_fluor.size);
    thisId.fIdentifier = "fluor_profile";
    l_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1,
      "fluor_profile")), &thisId, y->data[i1].fluor_profile.data, y->data[i1].
                       fluor_profile.size);
    thisId.fIdentifier = "cell_lengths";
    p_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i1,
      "cell_lengths")), &thisId, y->data[i1].cell_lengths.data, y->data[i1].
                       cell_lengths.size);
  }

  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                emxArray_real_T *y
 * Return Type  : void
 */
static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  y_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                uint16_T y_data[]
 *                int32_T y_size[2]
 * Return Type  : void
 */
static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, uint16_T y_data[], int32_T y_size[2])
{
  ab_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                real_T y_data[]
 *                int32_T y_size[2]
 * Return Type  : void
 */
static void l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2])
{
  bb_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                real_T y_data[]
 *                int32_T y_size[2]
 * Return Type  : void
 */
static void m_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2])
{
  cb_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                real_T y_data[]
 *                int32_T y_size[2]
 * Return Type  : void
 */
static void n_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2])
{
  db_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                real_T y_data[]
 *                int32_T y_size[2]
 * Return Type  : void
 */
static void o_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2])
{
  eb_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                real_T y_data[]
 *                int32_T y_size[2]
 * Return Type  : void
 */
static void p_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2])
{
  fb_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                struct4_T y[559]
 * Return Type  : void
 */
static void q_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct4_T y[559])
{
  emlrtMsgIdentifier thisId;
  int32_T iv2[2];
  int32_T i2;
  static const char * fieldNames[2] = { "frames", "bw_label" };

  thisId.fParent = parentId;
  for (i2 = 0; i2 < 2; i2++) {
    iv2[i2] = 1 + 558 * i2;
  }

  emlrtCheckStructR2012b(sp, parentId, u, 2, fieldNames, 2U, iv2);
  for (i2 = 0; i2 < 559; i2++) {
    thisId.fIdentifier = "frames";
    r_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i2, "frames")),
                       &thisId, y[i2].frames.data, y[i2].frames.size);
    thisId.fIdentifier = "bw_label";
    r_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, i2, "bw_label")),
                       &thisId, y[i2].bw_label.data, y[i2].bw_label.size);
  }

  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                real_T y_data[]
 *                int32_T y_size[2]
 * Return Type  : void
 */
static void r_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2])
{
  gb_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                char_T y[173]
 * Return Type  : void
 */
static void s_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[173])
{
  hb_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *c
 *                const char_T *identifier
 * Return Type  : real_T
 */
static real_T t_emlrt_marshallIn(const emlrtStack *sp, const mxArray *c, const
  char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = f_emlrt_marshallIn(sp, emlrtAlias(c), &thisId);
  emlrtDestroyArray(&c);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : boolean_T
 */
static boolean_T u_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId)
{
  boolean_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "logical", false, 0U, 0);
  ret = *mxGetLogicals(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                char_T ret[5]
 * Return Type  : void
 */
static void v_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[5])
{
  int32_T iv4[2];
  int32_T i3;
  for (i3 = 0; i3 < 2; i3++) {
    iv4[i3] = 1 + (i3 << 2);
  }

  emlrtCheckBuiltInR2012b(sp, msgId, src, "char", false, 2U, iv4);
  emlrtImportCharArrayR2014b(sp, src, ret, 5);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T
 */
static real_T w_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, 0);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                char_T ret[37]
 * Return Type  : void
 */
static void x_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[37])
{
  int32_T iv5[2];
  int32_T i4;
  for (i4 = 0; i4 < 2; i4++) {
    iv5[i4] = 1 + 36 * i4;
  }

  emlrtCheckBuiltInR2012b(sp, msgId, src, "char", false, 2U, iv5);
  emlrtImportCharArrayR2014b(sp, src, ret, 37);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                emxArray_real_T *ret
 * Return Type  : void
 */
static void y_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv6[2];
  int32_T i5;
  int32_T iv7[2];
  boolean_T bv1[2] = { true, true };

  for (i5 = 0; i5 < 2; i5++) {
    iv6[i5] = 312 + -2 * i5;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv6, &bv1[0],
    iv7);
  i5 = ret->size[0] * ret->size[1];
  ret->size[0] = iv7[0];
  ret->size[1] = iv7[1];
  emxEnsureCapacity((emxArray__common *)ret, i5, (int32_T)sizeof(real_T));
  emlrtImportArrayR2011b(src, ret->data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const mxArray * const prhs[2]
 *                const mxArray *plhs[1]
 * Return Type  : void
 */
void get_startlen_api(const mxArray * const prhs[2], const mxArray *plhs[1])
{
  real_T (*l_data)[1];
  static struct0_T f;
  real_T c;
  int32_T l_size[2];
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  l_data = (real_T (*)[1])mxMalloc(sizeof(real_T [1]));
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInitStruct_struct0_T(&st, &f, true);

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "f", &f);
  c = t_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "c");

  /* Invoke the target function */
  get_startlen(&f, c, *l_data, l_size);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*l_data, l_size);
  emxFreeStruct_struct0_T(&f);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void get_startlen_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  get_startlen_xil_terminate();
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void get_startlen_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void get_startlen_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_get_startlen_api.c
 *
 * [EOF]
 */
