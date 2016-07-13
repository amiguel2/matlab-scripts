/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: main.c
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 30-Nov-2015 14:22:03
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include Files */
#include "rt_nonfinite.h"
#include "get_startlen.h"
#include "main.h"
#include "get_startlen_terminate.h"
#include "get_startlen_emxAPI.h"
#include "get_startlen_initialize.h"

/* Function Declarations */
static void argInit_1x173_char_T(char result[173]);
static void argInit_1x37_char_T(char result[37]);
static void argInit_1x45_struct2_T(struct2_T result[45]);
static void argInit_1x559_struct4_T(struct4_T result[559]);
static void argInit_1x5_char_T(char result[5]);
static emxArray_struct3_T *argInit_1xd135_struct3_T(void);
static void argInit_1xd45_real_T(double result_data[], int result_size[2]);
static void argInit_1xd9_uint16_T(unsigned short result_data[], int result_size
  [2]);
static boolean_T argInit_boolean_T(void);
static char argInit_char_T(void);
static void argInit_d1xd1_real_T(double result_data[], int result_size[2]);
static void argInit_d1xd312_real_T(double result_data[], int result_size[2]);
static void argInit_d311xd1_real_T(double result_data[], int result_size[2]);
static void argInit_d312xd1_real_T(double result_data[], int result_size[2]);
static emxArray_real_T *argInit_d312xd310_real_T(void);
static void argInit_d313xd4_real_T(double result_data[], int result_size[2]);
static double argInit_real_T(void);
static void argInit_struct0_T(struct0_T *result);
static void argInit_struct1_T(struct1_T *result);
static struct2_T argInit_struct2_T(void);
static void argInit_struct3_T(struct3_T *result);
static void argInit_struct4_T(struct4_T *result);
static unsigned short argInit_uint16_T(void);
static void main_get_startlen(void);

/* Function Definitions */

/*
 * Arguments    : char result[173]
 * Return Type  : void
 */
static void argInit_1x173_char_T(char result[173])
{
  int b_j1;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 173; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[b_j1] = argInit_char_T();
  }
}

/*
 * Arguments    : char result[37]
 * Return Type  : void
 */
static void argInit_1x37_char_T(char result[37])
{
  int b_j1;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 37; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[b_j1] = argInit_char_T();
  }
}

/*
 * Arguments    : struct2_T result[45]
 * Return Type  : void
 */
static void argInit_1x45_struct2_T(struct2_T result[45])
{
  int b_j1;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 45; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[b_j1] = argInit_struct2_T();
  }
}

/*
 * Arguments    : struct4_T result[559]
 * Return Type  : void
 */
static void argInit_1x559_struct4_T(struct4_T result[559])
{
  int b_j1;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 559; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    argInit_struct4_T(&result[b_j1]);
  }
}

/*
 * Arguments    : char result[5]
 * Return Type  : void
 */
static void argInit_1x5_char_T(char result[5])
{
  int b_j1;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 5; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[b_j1] = argInit_char_T();
  }
}

/*
 * Arguments    : void
 * Return Type  : emxArray_struct3_T *
 */
static emxArray_struct3_T *argInit_1xd135_struct3_T(void)
{
  emxArray_struct3_T *result;
  static int iv0[2] = { 1, 2 };

  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_struct3_T(2, iv0);

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < result->size[1U]; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    argInit_struct3_T(&result->data[result->size[0] * b_j1]);
  }

  return result;
}

/*
 * Arguments    : double result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_1xd45_real_T(double result_data[], int result_size[2])
{
  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 1;
  result_size[1] = 2;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 2; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result_data[b_j1] = argInit_real_T();
  }
}

/*
 * Arguments    : unsigned short result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_1xd9_uint16_T(unsigned short result_data[], int result_size
  [2])
{
  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 1;
  result_size[1] = 2;

  /* Loop over the array to initialize each element. */
  for (b_j1 = 0; b_j1 < 2; b_j1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result_data[b_j1] = argInit_uint16_T();
  }
}

/*
 * Arguments    : void
 * Return Type  : boolean_T
 */
static boolean_T argInit_boolean_T(void)
{
  return false;
}

/*
 * Arguments    : void
 * Return Type  : char
 */
static char argInit_char_T(void)
{
  return '?';
}

/*
 * Arguments    : double result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_d1xd1_real_T(double result_data[], int result_size[2])
{
  int b_j0;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 1;
  result_size[1] = 1;

  /* Loop over the array to initialize each element. */
  b_j0 = 0;
  while (b_j0 < 1) {
    b_j0 = 0;
    while (b_j0 < 1) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result_data[0] = argInit_real_T();
      b_j0 = 1;
    }

    b_j0 = 1;
  }
}

/*
 * Arguments    : double result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_d1xd312_real_T(double result_data[], int result_size[2])
{
  int b_j0;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 1;
  result_size[1] = 2;

  /* Loop over the array to initialize each element. */
  b_j0 = 0;
  while (b_j0 < 1) {
    for (b_j0 = 0; b_j0 < 2; b_j0++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result_data[b_j0] = argInit_real_T();
    }

    b_j0 = 1;
  }
}

/*
 * Arguments    : double result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_d311xd1_real_T(double result_data[], int result_size[2])
{
  int b_j0;
  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 2;
  result_size[1] = 1;

  /* Loop over the array to initialize each element. */
  for (b_j0 = 0; b_j0 < 2; b_j0++) {
    b_j1 = 0;
    while (b_j1 < 1) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result_data[b_j0] = argInit_real_T();
      b_j1 = 1;
    }
  }
}

/*
 * Arguments    : double result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_d312xd1_real_T(double result_data[], int result_size[2])
{
  int b_j0;
  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 2;
  result_size[1] = 1;

  /* Loop over the array to initialize each element. */
  for (b_j0 = 0; b_j0 < 2; b_j0++) {
    b_j1 = 0;
    while (b_j1 < 1) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result_data[b_j0] = argInit_real_T();
      b_j1 = 1;
    }
  }
}

/*
 * Arguments    : void
 * Return Type  : emxArray_real_T *
 */
static emxArray_real_T *argInit_d312xd310_real_T(void)
{
  emxArray_real_T *result;
  static int iv1[2] = { 2, 2 };

  int b_j0;
  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(2, iv1);

  /* Loop over the array to initialize each element. */
  for (b_j0 = 0; b_j0 < result->size[0U]; b_j0++) {
    for (b_j1 = 0; b_j1 < result->size[1U]; b_j1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[b_j0 + result->size[0] * b_j1] = argInit_real_T();
    }
  }

  return result;
}

/*
 * Arguments    : double result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_d313xd4_real_T(double result_data[], int result_size[2])
{
  int b_j0;
  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 2;
  result_size[1] = 2;

  /* Loop over the array to initialize each element. */
  for (b_j0 = 0; b_j0 < 2; b_j0++) {
    for (b_j1 = 0; b_j1 < 2; b_j1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result_data[b_j0 + 2 * b_j1] = argInit_real_T();
    }
  }
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : struct0_T *result
 * Return Type  : void
 */
static void argInit_struct0_T(struct0_T *result)
{
  /* Set the value of each structure field.
     Change this value to the value that the application requires. */
  argInit_struct1_T(&result->param);
  argInit_1x45_struct2_T(result->frame);
  argInit_1x559_struct4_T(result->cell);
  argInit_1x173_char_T(result->outname);
}

/*
 * Arguments    : struct1_T *result
 * Return Type  : void
 */
static void argInit_struct1_T(struct1_T *result)
{
  /* Set the value of each structure field.
     Change this value to the value that the application requires. */
  result->linkq = argInit_boolean_T();
  argInit_1x5_char_T(result->typeq);
  result->growq = argInit_boolean_T();
  result->writeq = argInit_boolean_T();
  result->testq = argInit_boolean_T();
  result->rejq = argInit_boolean_T();
  result->f_areamin = argInit_real_T();
  result->f_areamax = argInit_real_T();
  result->f_hmin = argInit_real_T();
  result->f_hmin_split = argInit_real_T();
  result->f_gstd = argInit_real_T();
  result->f_back = argInit_real_T();
  result->f_histlim = argInit_real_T();
  result->f_Nit = argInit_real_T();
  result->f_r_int = argInit_real_T();
  result->f_kint = argInit_real_T();
  result->f_pert_same = argInit_real_T();
  result->f_frame_diff = argInit_real_T();
  argInit_1x37_char_T(result->outname);
}

/*
 * Arguments    : void
 * Return Type  : struct2_T
 */
static struct2_T argInit_struct2_T(void)
{
  struct2_T result;

  /* Set the value of each structure field.
     Change this value to the value that the application requires. */
  result.num_cells = argInit_real_T();
  result.object = argInit_1xd135_struct3_T();
  return result;
}

/*
 * Arguments    : struct3_T *result
 * Return Type  : void
 */
static void argInit_struct3_T(struct3_T *result)
{
  /* Set the value of each structure field.
     Change this value to the value that the application requires. */
  result->cellID = argInit_real_T();
  result->Xcont = argInit_d312xd310_real_T();
  result->Ycont = argInit_d312xd310_real_T();
  result->on_edge = argInit_boolean_T();
  argInit_1xd9_uint16_T(result->proxID.data, result->proxID.size);
  argInit_d312xd1_real_T(result->arc_length.data, result->arc_length.size);
  argInit_d1xd1_real_T(result->area.data, result->area.size);
  argInit_d1xd1_real_T(result->pole1.data, result->pole1.size);
  argInit_d1xd1_real_T(result->pole2.data, result->pole2.size);
  argInit_d1xd312_real_T(result->kappa_raw.data, result->kappa_raw.size);
  argInit_d312xd1_real_T(result->kappa_smooth.data, result->kappa_smooth.size);
  argInit_d1xd1_real_T(result->num_pts.data, result->num_pts.size);
  argInit_d313xd4_real_T(result->mesh.data, result->mesh.size);
  argInit_d1xd1_real_T(result->cell_length.data, result->cell_length.size);
  argInit_d1xd1_real_T(result->cell_width.data, result->cell_width.size);
  result->roc = argInit_real_T();
  argInit_d311xd1_real_T(result->fluor_interior.data,
    result->fluor_interior.size);
  argInit_d1xd1_real_T(result->ave_fluor.data, result->ave_fluor.size);
  argInit_d312xd1_real_T(result->fluor_profile.data, result->fluor_profile.size);
  argInit_d311xd1_real_T(result->cell_lengths.data, result->cell_lengths.size);
}

/*
 * Arguments    : struct4_T *result
 * Return Type  : void
 */
static void argInit_struct4_T(struct4_T *result)
{
  /* Set the value of each structure field.
     Change this value to the value that the application requires. */
  argInit_1xd45_real_T(result->frames.data, result->frames.size);
  argInit_1xd45_real_T(result->bw_label.data, result->bw_label.size);
}

/*
 * Arguments    : void
 * Return Type  : unsigned short
 */
static unsigned short argInit_uint16_T(void)
{
  return 0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_get_startlen(void)
{
  static struct0_T f;
  int l_size[2];
  double l_data[1];

  /* Initialize function 'get_startlen' input arguments. */
  /* Initialize function input argument 'f'. */
  argInit_struct0_T(&f);

  /* Call the entry-point 'get_startlen'. */
  get_startlen(&f, argInit_real_T(), l_data, l_size);
  emxDestroy_struct0_T(f);
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  get_startlen_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_get_startlen();

  /* Terminate the application.
     You do not need to do this more than one time. */
  get_startlen_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
