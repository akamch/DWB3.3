void endpl(void);
void openpl(char *);
void closepl(char *);
void tmp_xform (obj *);
void undo_tmpx (void);
void reset_line_weight(void);
void new_color(float val);
void chk_attrs (obj *);
void line(double, double, double, double);
void box(double, double, double, double, double);
void arrow(double, double, double, double, double, double, double, int);
void arc_arrow(obj *);
void spline(int, int, valtype *);
void pline(int, int, valtype *, double);
void ellipse(double, double, double, double, double, double, double, double,
    int);
void newlabel(int, char *, int, double, double, double, double);
void addlabel(int, char *, int, double, double);
void resetfont(int, double);
void puteps(obj *);
