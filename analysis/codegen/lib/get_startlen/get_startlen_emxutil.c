/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: get_startlen_emxutil.c
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 30-Nov-2015 14:22:03
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "get_startlen.h"
#include "get_startlen_emxutil.h"

/* Function Declarations */
static void emxFreeMatrix_struct2_T(struct2_T pMatrix[45]);
static void emxFreeMatrix_struct4_T(void);
static void emxFreeStruct_struct2_T(struct2_T *pStruct);
static void emxFreeStruct_struct3_T(struct3_T *pStruct);
static void emxInitMatrix_struct2_T(struct2_T pMatrix[45]);
static void emxInitMatrix_struct4_T(struct4_T pMatrix[559]);
static void emxInitStruct_struct2_T(struct2_T *pStruct);
static void emxInitStruct_struct4_T(struct4_T *pStruct);

/* Function Definitions */

/*
 * Arguments    : struct2_T pMatrix[45]
 * Return Type  : void
 */
static void emxFreeMatrix_struct2_T(struct2_T pMatrix[45])
{
  int i;
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
 * Arguments    : struct2_T pMatrix[45]
 * Return Type  : void
 */
static void emxInitMatrix_struct2_T(struct2_T pMatrix[45])
{
  int i;
  for (i = 0; i < 45; i++) {
    emxInitStruct_struct2_T(&pMatrix[i]);
  }
}

/*
 * Arguments    : struct4_T pMatrix[559]
 * Return Type  : void
 */
static void emxInitMatrix_struct4_T(struct4_T pMatrix[559])
{
  int i;
  for (i = 0; i < 559; i++) {
    emxInitStruct_struct4_T(&pMatrix[i]);
  }
}

/*
 * Arguments    : struct2_T *pStruct
 * Return Type  : void
 */
static void emxInitStruct_struct2_T(struct2_T *pStruct)
{
  emxInit_struct3_T(&pStruct->object, 2);
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
 * Arguments    : struct0_T *pStruct
 * Return Type  : void
 */
void emxFreeStruct_struct0_T(struct0_T *pStruct)
{
  emxFreeMatrix_struct2_T(pStruct->frame);
  emxFreeMatrix_struct4_T();
}

/*
 * Arguments    : emxArray_real_T **pEmxArray
 * Return Type  : void
 */
void emxFree_real_T(emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (double *)NULL) && (*pEmxArray)->canFreeData) {
      free((void *)(*pEmxArray)->data);
    }

    free((void *)(*pEmxArray)->size);
    free((void *)*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

/*
 * Arguments    : emxArray_struct3_T **pEmxArray
 * Return Type  : void
 */
void emxFree_struct3_T(emxArray_struct3_T **pEmxArray)
{
  int numEl;
  int i;
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
        free((void *)(*pEmxArray)->data);
      }
    }

    free((void *)(*pEmxArray)->size);
    free((void *)*pEmxArray);
    *pEmxArray = (emxArray_struct3_T *)NULL;
  }
}

/*
 * Arguments    : struct0_T *pStruct
 * Return Type  : void
 */
void emxInitStruct_struct0_T(struct0_T *pStruct)
{
  emxInitMatrix_struct2_T(pStruct->frame);
  emxInitMatrix_struct4_T(pStruct->cell);
}

/*
 * Arguments    : emxArray_real_T **pEmxArray
 *                int numDimensions
 * Return Type  : void
 */
void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions)
{
  emxArray_real_T *emxArray;
  int i;
  *pEmxArray = (emxArray_real_T *)malloc(sizeof(emxArray_real_T));
  emxArray = *pEmxArray;
  emxArray->data = (double *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int *)malloc((unsigned int)(sizeof(int) * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/*
 * Arguments    : emxArray_struct3_T **pEmxArray
 *                int numDimensions
 * Return Type  : void
 */
void emxInit_struct3_T(emxArray_struct3_T **pEmxArray, int numDimensions)
{
  emxArray_struct3_T *emxArray;
  int i;
  *pEmxArray = (emxArray_struct3_T *)malloc(sizeof(emxArray_struct3_T));
  emxArray = *pEmxArray;
  emxArray->data = (struct3_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int *)malloc((unsigned int)(sizeof(int) * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/*
 * File trailer for get_startlen_emxutil.c
 *
 * [EOF]
 */
