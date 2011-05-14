% A MODULE THAT FINDS A COMMON OUTLINE FOR A PAIR OF PATHS
% (An excerpt from a plain extension, made in BOP, bop@bop.com.pl)
% 
% The problem can be stated as follows: given are two path (precisely:
% expressions of type `path'); assume that the positively directed
% (anti-clockwise) path accomplishes filling, and negatively directed
% (clockwise)---erasing; the task is to find the outline of the resulting
% (visible) figure. Such a task is known as ``removing overlaps''
% which seems too narrow for such a complex operation. Actually,
% the basic macro of that part, i.e., `find_outlines,' accomplishes
% set-theory operations: sum, difference and product, depending on the
% turning number of the input paths.
% ---
def && = amp_amp_ whatever enddef;
tertiarydef p amp_amp_ q = % |length(p)>0|
 (subpath(0,length(p)-1) of p) .. controls (postcontrol length(p)-1 of p) 
  and (precontrol length(p) of p) .. 
enddef;
% ---
vardef pos_subpath expr z of p =
 if not cycle p: subpath z of p else:
  if xpart(z)<=ypart(z): subpath z of p
  else: subpath (xpart(z),ypart(z)+length(p)) of p fi
 fi
enddef;
% ---
vardef turn_ang(expr za,zb) =
 if (abs(za)>=1/1000) and (abs(zb)>=1/1000): % |eps| may be not enough
  angle(unitvector(za) zscaled (unitvector(zb) reflectedabout (origin,right)))
 else: whatever fi
enddef;
% ---
vardef feasible_cross(suffix p,q,v)(expr c,s) =
 if v[c]: (s*turn_ang(direction p[c] of p, direction q[c] of q)>0)
 else: false fi
enddef;
% ---
vardef recombine(suffix p, r) =
 save s_,e_,v_,n_; boolean v_[\\]; path r[\\];
 r.num:=0; s_:=turningnumber(p1)*turningnumber(p2);
 for i_:=1 upto p.num: v_[i_]:=true; endfor
 forever:
  save c_; c_:=0;
  forever:
   c_:=c_+1; exitif c_>p.num; exitif feasible_cross(p1,p2,v_,c_,s_);
  endfor
  exitif c_>p.num;
  e_:=1;
  r[incr r.num]:=
   forever:
    hide(e_:=3-e_; v_[c_]:=false; n_:=next_time(p[e_])(c_))
    (pos_subpath (p[e_][c_],p[e_][n_]) of p[e_]) hide(c_:=n_) &&
    exitif not v_[n_];
   endfor
   cycle;
 endfor
enddef;
% ---
vardef next_time(suffix p)(expr t) =
 save c_;
 for i_:=1 upto p.num:
  if (p[i_]>p[t]):
   if known c_: if p[i_]<p[c_]: c_:=i_; fi else: c_:=i_; fi
  fi
 endfor
 if unknown c_:
  c_=1; for i_:=2 upto p.num: if p[i_]<p[c_]: c_:=i_; fi endfor
 fi
 c_
enddef;
% ---
vardef feasible_time(suffix p)(expr t) =
 save b_,i_; boolean b_; b_:=true; i_:=0;
 forever:
  i_:=i_+1;
  exitif (unknown p[i_]) or (not b_);
  b_:=b_ if (abs(p[i_]-t)<1) or (abs(p[i_]-t)>length(p)-1): % optimization?
   and (arclength( pos_subpath(p[i_],t) of p ) > acc_eps)
   and (arclength( pos_subpath(t,p[i_]) of p ) > acc_eps)
  fi;
 endfor
 b_
enddef;
% ---
vardef intersect_curves(suffix p) =
 save l_,p_; l_:=0;
 for i_:=0 upto length(p1)-1:
  for j_:=0 upto length(p2)-1:
   for k_:=1 upto
    intersect_segments(subpath (i_,i_+1) of p1, subpath (j_,j_+1) of p2)(p_):
% assuming that there are no selfintersections, it suffices to check
% feasibility only for |p1|:
    if feasible_time(p1, p_1[k_]+i_):
     p1[incr l_]=p_1[k_]+i_; p2[l_]=p_2[k_]+j_;
    fi
   endfor
  endfor
 endfor
 p.num:=p1num:=p2num:=l_;
enddef;
% ---
vardef intersect_segments(expr a,b)(suffix p) =
 save ta_,tb_; (ta_,tb_)=a intersectiontimes b;
 if ta_>=0:
  p1[1]:=ta_; p2[1]:=tb_;
  save tc_,td_; (tc_,td_)=reverse a intersectiontimes reverse b;
  if length(1/2[point ta_ of a, point tb_ of b]
   -1/2[point tc_ of reverse a, point td_ of reverse b])>acc_eps:
   p1[2]:=1-tc_; p2[2]:=1-td_; 1+ \\ fi \\ 1
 else: 0 fi
enddef;
newinternal acc_eps; acc_eps:=.5;
%
% The arguments to the macro `find_outlines' must comply with
% the following assumptions:
% * paths are cyclic;
% * no selfintersections occur;
% * no tangent touching occur;
% * no inflection points occur;
% * segments are long enough.
% Further improvements:
% * intersection points nearly coinciding with
%   nodes should be replaced by nodes, i.e., an integer time.
% ---
vardef find_outlines(expr a,b)(suffix r) = % |a|, |b| -- input, |r| -- output
 save q_; path q_[\\]; q_1=a; q_2=b; numeric q_[\\][\\];
 intersect_curves(q_);
 if q_.num=0: % emergency?
  r.num:=-2; path r[\\]; r1:=a; r2:=b;
 else: recombine(q_,r); fi
enddef;
endinput

