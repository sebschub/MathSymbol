vardef is_less(expr a,b) = (a<b) enddef;
vardef quicksort@#(expr ii,jj)(suffix s)(text t) =
% sorts |@#.s[ii..jj]| along with |@#.$[ii..jj]| for |$| in |t|,
% using Tony Hoare's ``quick sort'' method; suffix |s| must must not occur
% in the |t| list (no checking is performed); if both |s| and |t| are empty,
% |t| is ignored.
% REMARK 1: the algorithm has no explicit recursion, because of MF/MP limits
%           on recursion level.
% REMARK 2: the algorithm, of course, is not stable, i.e., it does not
%           preserve the order of equal items, but it does not matter here
 save i_,j_,k_,l_,cell_,stack_,incl_t_; boolean incl_t_;
 pair stack_[\\]; stack_.lev:=0; stack_[incr stack_.lev]:=(ii,jj);
 i_:=0; for $:=t: i_:=i_+1; endfor % ``measure'' |t|-list
 incl_t_:=(str s <> "") or ((str s = "") and (i_<>0));
 forsuffixes $:= s if incl_t_: , t fi:
  if numeric @#.$[ii]: numeric cell_.$;
  elseif string @#.$[ii]: string cell_.$;
  elseif boolean @#.$[ii]: boolean cell_.$;
  fi
 endfor
 forever:
 exitif stack_.lev<=0;
  numeric i_,j_; (i_,j_)=stack_[stack_.lev]; stack_.lev:=stack_.lev-1;
  if i_<j_:
   forsuffixes $:= s if incl_t_: , t fi: cell_.$:=@#.$[i_]; endfor
   l_:=i_;
   for k_:=i_+1 upto j_:
    if is_less(@#.s[k_],cell_.s):
     forsuffixes $:=s if incl_t_: , t fi:
      @#.$[l_]:=@#.$[k_]; @#.$[k_]:=@#.$[l_+1];
     endfor
     l_:=l_+1;
    fi
   endfor
   forsuffixes $:= s if incl_t_: , t fi: @#.$[l_]:=cell_.$; endfor
   stack_[incr stack_.lev]:=(i_,l_-1); stack_[incr stack_.lev]:=(l_+1,j_);
  fi
 endfor
enddef;
endinput
