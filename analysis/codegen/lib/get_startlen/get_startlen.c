/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: get_startlen.c
 *
 * MATLAB Coder version            : 2.8
 * C/C++ source code generated on  : 30-Nov-2015 14:22:03
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "get_startlen.h"

/* Function Definitions */

/*
 * get_startlen(f,c) returns
 * Arguments    : const struct0_T *f
 *                double c
 *                double l_data[]
 *                int l_size[2]
 * Return Type  : void
 */
void get_startlen(const struct0_T *f, double c, double l_data[], int l_size[2])
{
  int loop_ub;
  int i0;
  l_size[0] = f->frame[(int)f->cell[(int)c - 1].frames.data[0] - 1].object->
    data[(int)f->cell[(int)c - 1].bw_label.data[0] - 1].cell_length.size[0];
  l_size[1] = f->frame[(int)f->cell[(int)c - 1].frames.data[0] - 1].object->
    data[(int)f->cell[(int)c - 1].bw_label.data[0] - 1].cell_length.size[1];
  loop_ub = f->frame[(int)f->cell[(int)c - 1].frames.data[0] - 1].object->data
    [(int)f->cell[(int)c - 1].bw_label.data[0] - 1].cell_length.size[0] *
    f->frame[(int)f->cell[(int)c - 1].frames.data[0] - 1].object->data[(int)
    f->cell[(int)c - 1].bw_label.data[0] - 1].cell_length.size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    l_data[i0] = f->frame[(int)f->cell[(int)c - 1].frames.data[0] - 1]
      .object->data[(int)f->cell[(int)c - 1].bw_label.data[0] - 1].
      cell_length.data[i0];
  }
}

/*
 * File trailer for get_startlen.c
 *
 * [EOF]
 */
