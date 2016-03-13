# include "e.h"
# include "y.tab.h"

extern YYSTYPE yyval;

int	csp;
int	psp;
#define	CSSIZE	400
char	cs[420];

int	lf, rf;	/* temporary spots for left and right fonts */

void
text(int t, char *p1) {
	int c;
	char *p;
	tbl *tp;
	extern tbl *restbl;

	yyval.token = oalloc();
	ebase[yyval.token] = 0;
	eht[yyval.token] = VERT(2);	/* 2 half-spaces */
	lfont[yyval.token] = rfont[yyval.token] = ROM;
	if (t == QTEXT)
		p = p1;
	else if ( t == SPACE )
		p = "\\ ";
	else if ( t == THIN )
		p = "\\|";
	else if ( t == TAB )
		p = "\\t";
	else if ((tp = lookup(&restbl, p1, NULL)) != NULL)
		p = tp->defn;
	else {
		lf = rf = 0;
		for (csp=psp=0; (c=p1[psp++])!='\0';) {
			rf = trans(c, p1);
			if (lf == 0)
				lf = rf;	/* save first */
			if (csp>CSSIZE)
				error(FATAL,"converted token %.25s... too long",p1);
		}
		cs[csp] = '\0';
		p = cs;
		lfont[yyval.token] = lf;
		rfont[yyval.token] = rf;
	}
	if (dbg)
		printf(".\t%dtext: S%d <- %s; b=%d,h=%d,lf=%c,rf=%c\n",
		    t, yyval.token, p, ebase[yyval.token], eht[yyval.token],
		    lfont[yyval.token], rfont[yyval.token]);
	printf(".ds %d \"%s\n", yyval.token, p);
}

int
trans(int c, char *p1) {
	int f;
	f = ROM;
	switch( c) {
	case '0': case '1': case '2': case '3': case '4':
	case '5': case '6': case '7': case '8': case '9':
	case ':': case ';': case '!': case '%':
	case '(': case '[': case ')': case ']':
	case ',':
		if (rf == ITAL)
			shim();
		roman(c); break;
	case '.':
		if (rf == ROM)
			roman(c);
		else
			cs[csp++] = c;
		f = rf;
		break;
	case '|':
		if (rf == ITAL)
			shim();
		shim(); roman(c); shim(); break;
	case '=':
		if (rf == ITAL)
			shim();
		name4('e','q');
		break;
	case '+':
		if (rf == ITAL)
			shim();
		name4('p', 'l');
		break;
	case '>': case '<':
		if (rf == ITAL)
			shim();
		if (p1[psp]=='=') {	/* look ahead for == <= >= */
			name4(c,'=');
			psp++;
		} else {
			cs[csp++] = c;  
		}
		break;
	case '-':
		if (rf == ITAL)
			shim();
		if (p1[psp]=='>') {
			name4('-','>'); psp++;
		} else {
			name4('m','i');
		}
		break;
	case '/':
		if (rf == ITAL)
			shim();
		name4('s','l');
		break;
	case '~': case ' ':
		shim(); shim(); break;
	case '^':
		shim(); break;
	case '\\':	/* troff - pass 2 or 3 more chars */
		if (rf == ITAL)
			shim();
		cs[csp++] = c; cs[csp++] = c = p1[psp++]; cs[csp++] = p1[psp++];
		if (c=='(') cs[csp++] = p1[psp++];
		if (c=='*' && cs[csp-1] == '(') {
			cs[csp++] = p1[psp++];
			cs[csp++] = p1[psp++];
		}
		break;
	case '\'':
		cs[csp++] = '\\'; cs[csp++] = 'f'; cs[csp++] = rf==ITAL ? ITAL : ROM;
		name4('f','m');
		cs[csp++] = '\\'; cs[csp++] = 'f'; cs[csp++] = 'P';
		f = rf==ITAL ? ITAL : ROM;
		break;

	case 'f':
		if (ft == ITAL) {
			cs[csp++] = '\\'; cs[csp++] = '^';
			cs[csp++] = 'f';
			cs[csp++] = '\\'; cs[csp++] = '|';	/* trying | instead of ^ */
			f = ITAL;
		}
		else
			cs[csp++] = 'f';
		break;
	case 'j':
		if (ft == ITAL) {
			cs[csp++] = '\\'; cs[csp++] = '^';
			cs[csp++] = 'j';
			f = ITAL;
		}
		else
			cs[csp++] = 'j';
		break;
	default:
		cs[csp++] = c;
		f = ft==ITAL ? ITAL : ROM;
		break;
	}
	return(f);
}

void
shim(void) {
	cs[csp++] = '\\'; cs[csp++] = '|';
}

void
roman(int c) {
	cs[csp++] = '\\'; cs[csp++] = 'f'; cs[csp++] = ROM;
	cs[csp++] = c;
	cs[csp++] = '\\'; cs[csp++] = 'f'; cs[csp++] = 'P';
}

void
name4(int c1, int c2) {
	cs[csp++] = '\\';
	cs[csp++] = '(';
	cs[csp++] = c1;
	cs[csp++] = c2;
}
