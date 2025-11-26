------------------------------ MODULE test_conditionals ------------------------------
EXTENDS Integers, FiniteSets, Sequences
CONSTANT GLOBAL_INIT,PROCESS,UNDEF

(*--algorithm test_conditionals
variables
    mem = <<>>;
    tmpArrayFill = 0;
    initDone = FALSE;


define
    RECURSIVE load(_,_)
    load(stk, ptr) == IF "ptr" \in DOMAIN ptr THEN
                         load(stk, ptr.ptr)[ptr.ref]
                      ELSE
                         IF ptr.loc = "stack"
                         THEN stk[Len(stk) - (ptr.fp + ptr.offs)]
                         ELSE mem[Len(mem) - ptr.offs]

    RECURSIVE idx_seq(_,_)
    idx_seq(stk, ptr) == IF "ptr" \in DOMAIN ptr THEN
                         idx_seq(stk, ptr.ptr) \o <<ptr.ref>>
                      ELSE
                         IF ptr.loc = "stack"
                         THEN <<"stack", Len(stk) - (ptr.fp + ptr.offs)>>
                         ELSE <<"mem", Len(mem) - ptr.offs>>

    RECURSIVE update_stack(_,_,_)
    update_stack(stk, val, seq) == IF seq = <<>>
                                    THEN val
                                    ELSE [stk EXCEPT ![seq[1]] = update_stack(stk[seq[1]], val, Tail(seq))]
end define;

macro push(my_stack, val) begin
    my_stack := <<val>> \o my_stack;
end macro;

macro pop(my_stack) begin
    my_stack := Tail(my_stack);
end macro;

macro decl(val, ptr) begin
    if ptr.loc = "stack" then
        push(my_stack, val);
        ptr.offs := Len(my_stack) - ptr.fp - 1;
    else
        push(mem, val);
        ptr.offs := Len(mem) - 1;
    end if;
end macro;

macro store(val, ptr) begin
  with seq = idx_seq(my_stack, ptr) do
  if seq[1] = "stack"
    then my_stack := update_stack(my_stack, val, Tail(seq));
    else mem := update_stack(mem, val, Tail(seq));
  end if;
  end with;
end macro;

macro attr_return(ret, ptr) begin
    store(Head(ret), ptr);
    pop(ret);
end macro;

procedure init_array(size, arr_ptr) begin
  InitArray:
  tmpArrayFill := 0;
  store(<<>>, arr_ptr);

  WhileInitArray:
  while(tmpArrayFill < size) do
    store(Append(load(my_stack, arr_ptr), UNDEF), arr_ptr);
    tmpArrayFill := tmpArrayFill + 1;
  end while;

  return;
end procedure;

procedure stacks_init()
variables
    my_stack = <<>>;
    ret = <<>>;
begin
    InitStack:
    return;
end procedure;

procedure max(a_max,b_max)
variables
    a_ptr_max = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    b_ptr_max = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    __retres_ptr_max = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
begin
    Line0_max:
    decl(b_max,b_ptr_max);

    Line1_max:
    decl(a_max,a_ptr_max);

    Line2_max:
    decl(UNDEF,__retres_ptr_max);

    Line3_max:
    if((load(my_stack, a_ptr_max)>load(my_stack, b_ptr_max))) then
        Line3_max0:
        store(load(my_stack, a_ptr_max), __retres_ptr_max);

        Line3_max1:
        goto return_label;

    else
        Line3_max2:
        store(load(my_stack, b_ptr_max), __retres_ptr_max);

        Line3_max3:
        goto return_label;

    end if;

    return_label:
    skip;

    Line5_max:
    push(ret, load(my_stack, __retres_ptr_max));

    Line6_max:
    pop(my_stack);

    Line7_max:
    pop(my_stack);

    Line8_max:
    pop(my_stack);

    End_max:
    return;
end procedure;

procedure main()
variables
    x_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    y_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    result_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
begin
    Line0_main:
    decl(UNDEF,result_ptr_main);

    Line1_main:
    decl(UNDEF,y_ptr_main);

    Line2_main:
    decl(UNDEF,x_ptr_main);

    Line3_main:
    store(5, x_ptr_main);

    Line4_main:
    store(10, y_ptr_main);

    Line5_main:
    call max(load(my_stack, x_ptr_main),load(my_stack, y_ptr_main));

    Line6_main:
    attr_return(ret, result_ptr_main);

    Line7_main:
    if((load(my_stack, result_ptr_main)>8)) then
        Line7_main0:
        store((load(my_stack, result_ptr_main)*2), result_ptr_main);

    else
        Line7_main1:
        skip;
    end if;

    Line8_main:
    push(ret, load(my_stack, result_ptr_main));

    Line9_main:
    pop(my_stack);

    Line10_main:
    pop(my_stack);

    Line11_main:
    pop(my_stack);

    End_main:
    return;
end procedure;

fair process globalInit \in GLOBAL_INIT
variables

begin
    Line0_globalInit:
    initDone := TRUE;

end process;
fair process proc \in PROCESS
variables

begin
    Line0_proc:
    await initDone = TRUE;

    Line1_proc:
    call main();

end process;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "64905daa" /\ chksum(tla) = "fcf4edeb")
CONSTANT defaultInitValue
VARIABLES mem, tmpArrayFill, initDone, pc, stack

(* define statement *)
RECURSIVE load(_,_)
load(stk, ptr) == IF "ptr" \in DOMAIN ptr THEN
                     load(stk, ptr.ptr)[ptr.ref]
                  ELSE
                     IF ptr.loc = "stack"
                     THEN stk[Len(stk) - (ptr.fp + ptr.offs)]
                     ELSE mem[Len(mem) - ptr.offs]

RECURSIVE idx_seq(_,_)
idx_seq(stk, ptr) == IF "ptr" \in DOMAIN ptr THEN
                     idx_seq(stk, ptr.ptr) \o <<ptr.ref>>
                  ELSE
                     IF ptr.loc = "stack"
                     THEN <<"stack", Len(stk) - (ptr.fp + ptr.offs)>>
                     ELSE <<"mem", Len(mem) - ptr.offs>>

RECURSIVE update_stack(_,_,_)
update_stack(stk, val, seq) == IF seq = <<>>
                                THEN val
                                ELSE [stk EXCEPT ![seq[1]] = update_stack(stk[seq[1]], val, Tail(seq))]

VARIABLES size, arr_ptr, my_stack, ret, a_max, b_max, a_ptr_max, b_ptr_max, 
          __retres_ptr_max, x_ptr_main, y_ptr_main, result_ptr_main

vars == << mem, tmpArrayFill, initDone, pc, stack, size, arr_ptr, my_stack, 
           ret, a_max, b_max, a_ptr_max, b_ptr_max, __retres_ptr_max, 
           x_ptr_main, y_ptr_main, result_ptr_main >>

ProcSet == (GLOBAL_INIT) \cup (PROCESS)

Init == (* Global variables *)
        /\ mem = <<>>
        /\ tmpArrayFill = 0
        /\ initDone = FALSE
        (* Procedure init_array *)
        /\ size = [ self \in ProcSet |-> defaultInitValue]
        /\ arr_ptr = [ self \in ProcSet |-> defaultInitValue]
        (* Procedure stacks_init *)
        /\ my_stack = [ self \in ProcSet |-> <<>>]
        /\ ret = [ self \in ProcSet |-> <<>>]
        (* Procedure max *)
        /\ a_max = [ self \in ProcSet |-> defaultInitValue]
        /\ b_max = [ self \in ProcSet |-> defaultInitValue]
        /\ a_ptr_max = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ b_ptr_max = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ __retres_ptr_max = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        (* Procedure main *)
        /\ x_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ y_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ result_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ stack = [self \in ProcSet |-> << >>]
        /\ pc = [self \in ProcSet |-> CASE self \in GLOBAL_INIT -> "Line0_globalInit"
                                        [] self \in PROCESS -> "Line0_proc"]

InitArray(self) == /\ pc[self] = "InitArray"
                   /\ tmpArrayFill' = 0
                   /\ LET seq == idx_seq(my_stack[self], arr_ptr[self]) IN
                        IF seq[1] = "stack"
                           THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (<<>>), Tail(seq))]
                                /\ mem' = mem
                           ELSE /\ mem' = update_stack(mem, (<<>>), Tail(seq))
                                /\ UNCHANGED my_stack
                   /\ pc' = [pc EXCEPT ![self] = "WhileInitArray"]
                   /\ UNCHANGED << initDone, stack, size, arr_ptr, ret, a_max, 
                                   b_max, a_ptr_max, b_ptr_max, 
                                   __retres_ptr_max, x_ptr_main, y_ptr_main, 
                                   result_ptr_main >>

WhileInitArray(self) == /\ pc[self] = "WhileInitArray"
                        /\ IF (tmpArrayFill < size[self])
                              THEN /\ LET seq == idx_seq(my_stack[self], arr_ptr[self]) IN
                                        IF seq[1] = "stack"
                                           THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (Append(load(my_stack[self], arr_ptr[self]), UNDEF)), Tail(seq))]
                                                /\ mem' = mem
                                           ELSE /\ mem' = update_stack(mem, (Append(load(my_stack[self], arr_ptr[self]), UNDEF)), Tail(seq))
                                                /\ UNCHANGED my_stack
                                   /\ tmpArrayFill' = tmpArrayFill + 1
                                   /\ pc' = [pc EXCEPT ![self] = "WhileInitArray"]
                                   /\ UNCHANGED << stack, size, arr_ptr >>
                              ELSE /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                                   /\ size' = [size EXCEPT ![self] = Head(stack[self]).size]
                                   /\ arr_ptr' = [arr_ptr EXCEPT ![self] = Head(stack[self]).arr_ptr]
                                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                                   /\ UNCHANGED << mem, tmpArrayFill, my_stack >>
                        /\ UNCHANGED << initDone, ret, a_max, b_max, a_ptr_max, 
                                        b_ptr_max, __retres_ptr_max, 
                                        x_ptr_main, y_ptr_main, 
                                        result_ptr_main >>

init_array(self) == InitArray(self) \/ WhileInitArray(self)

InitStack(self) == /\ pc[self] = "InitStack"
                   /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                   /\ my_stack' = [my_stack EXCEPT ![self] = Head(stack[self]).my_stack]
                   /\ ret' = [ret EXCEPT ![self] = Head(stack[self]).ret]
                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                   a_max, b_max, a_ptr_max, b_ptr_max, 
                                   __retres_ptr_max, x_ptr_main, y_ptr_main, 
                                   result_ptr_main >>

stacks_init(self) == InitStack(self)

Line0_max(self) == /\ pc[self] = "Line0_max"
                   /\ IF b_ptr_max[self].loc = "stack"
                         THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<b_max[self]>> \o my_stack[self]]
                              /\ b_ptr_max' = [b_ptr_max EXCEPT ![self].offs = Len(my_stack'[self]) - b_ptr_max[self].fp - 1]
                              /\ mem' = mem
                         ELSE /\ mem' = <<b_max[self]>> \o mem
                              /\ b_ptr_max' = [b_ptr_max EXCEPT ![self].offs = Len(mem') - 1]
                              /\ UNCHANGED my_stack
                   /\ pc' = [pc EXCEPT ![self] = "Line1_max"]
                   /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                   __retres_ptr_max, x_ptr_main, y_ptr_main, 
                                   result_ptr_main >>

Line1_max(self) == /\ pc[self] = "Line1_max"
                   /\ IF a_ptr_max[self].loc = "stack"
                         THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<a_max[self]>> \o my_stack[self]]
                              /\ a_ptr_max' = [a_ptr_max EXCEPT ![self].offs = Len(my_stack'[self]) - a_ptr_max[self].fp - 1]
                              /\ mem' = mem
                         ELSE /\ mem' = <<a_max[self]>> \o mem
                              /\ a_ptr_max' = [a_ptr_max EXCEPT ![self].offs = Len(mem') - 1]
                              /\ UNCHANGED my_stack
                   /\ pc' = [pc EXCEPT ![self] = "Line2_max"]
                   /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, ret, a_max, b_max, b_ptr_max, 
                                   __retres_ptr_max, x_ptr_main, y_ptr_main, 
                                   result_ptr_main >>

Line2_max(self) == /\ pc[self] = "Line2_max"
                   /\ IF __retres_ptr_max[self].loc = "stack"
                         THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                              /\ __retres_ptr_max' = [__retres_ptr_max EXCEPT ![self].offs = Len(my_stack'[self]) - __retres_ptr_max[self].fp - 1]
                              /\ mem' = mem
                         ELSE /\ mem' = <<UNDEF>> \o mem
                              /\ __retres_ptr_max' = [__retres_ptr_max EXCEPT ![self].offs = Len(mem') - 1]
                              /\ UNCHANGED my_stack
                   /\ pc' = [pc EXCEPT ![self] = "Line3_max"]
                   /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                   b_ptr_max, x_ptr_main, y_ptr_main, 
                                   result_ptr_main >>

Line3_max(self) == /\ pc[self] = "Line3_max"
                   /\ IF ((load(my_stack[self], a_ptr_max[self])>load(my_stack[self], b_ptr_max[self])))
                         THEN /\ pc' = [pc EXCEPT ![self] = "Line3_max0"]
                         ELSE /\ pc' = [pc EXCEPT ![self] = "Line3_max2"]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, my_stack, ret, a_max, b_max, 
                                   a_ptr_max, b_ptr_max, __retres_ptr_max, 
                                   x_ptr_main, y_ptr_main, result_ptr_main >>

Line3_max0(self) == /\ pc[self] = "Line3_max0"
                    /\ LET seq == idx_seq(my_stack[self], __retres_ptr_max[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (load(my_stack[self], a_ptr_max[self])), Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, (load(my_stack[self], a_ptr_max[self])), Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line3_max1"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main, result_ptr_main >>

Line3_max1(self) == /\ pc[self] = "Line3_max1"
                    /\ pc' = [pc EXCEPT ![self] = "return_label"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, a_max, b_max, 
                                    a_ptr_max, b_ptr_max, __retres_ptr_max, 
                                    x_ptr_main, y_ptr_main, result_ptr_main >>

Line3_max2(self) == /\ pc[self] = "Line3_max2"
                    /\ LET seq == idx_seq(my_stack[self], __retres_ptr_max[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (load(my_stack[self], b_ptr_max[self])), Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, (load(my_stack[self], b_ptr_max[self])), Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line3_max3"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main, result_ptr_main >>

Line3_max3(self) == /\ pc[self] = "Line3_max3"
                    /\ pc' = [pc EXCEPT ![self] = "return_label"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, a_max, b_max, 
                                    a_ptr_max, b_ptr_max, __retres_ptr_max, 
                                    x_ptr_main, y_ptr_main, result_ptr_main >>

return_label(self) == /\ pc[self] = "return_label"
                      /\ TRUE
                      /\ pc' = [pc EXCEPT ![self] = "Line5_max"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, my_stack, ret, a_max, b_max, 
                                      a_ptr_max, b_ptr_max, __retres_ptr_max, 
                                      x_ptr_main, y_ptr_main, result_ptr_main >>

Line5_max(self) == /\ pc[self] = "Line5_max"
                   /\ ret' = [ret EXCEPT ![self] = <<(load(my_stack[self], __retres_ptr_max[self]))>> \o ret[self]]
                   /\ pc' = [pc EXCEPT ![self] = "Line6_max"]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, my_stack, a_max, b_max, a_ptr_max, 
                                   b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                   y_ptr_main, result_ptr_main >>

Line6_max(self) == /\ pc[self] = "Line6_max"
                   /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                   /\ pc' = [pc EXCEPT ![self] = "Line7_max"]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                   b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                   y_ptr_main, result_ptr_main >>

Line7_max(self) == /\ pc[self] = "Line7_max"
                   /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                   /\ pc' = [pc EXCEPT ![self] = "Line8_max"]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                   b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                   y_ptr_main, result_ptr_main >>

Line8_max(self) == /\ pc[self] = "Line8_max"
                   /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                   /\ pc' = [pc EXCEPT ![self] = "End_max"]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                   arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                   b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                   y_ptr_main, result_ptr_main >>

End_max(self) == /\ pc[self] = "End_max"
                 /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                 /\ a_ptr_max' = [a_ptr_max EXCEPT ![self] = Head(stack[self]).a_ptr_max]
                 /\ b_ptr_max' = [b_ptr_max EXCEPT ![self] = Head(stack[self]).b_ptr_max]
                 /\ __retres_ptr_max' = [__retres_ptr_max EXCEPT ![self] = Head(stack[self]).__retres_ptr_max]
                 /\ a_max' = [a_max EXCEPT ![self] = Head(stack[self]).a_max]
                 /\ b_max' = [b_max EXCEPT ![self] = Head(stack[self]).b_max]
                 /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                 /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                 my_stack, ret, x_ptr_main, y_ptr_main, 
                                 result_ptr_main >>

max(self) == Line0_max(self) \/ Line1_max(self) \/ Line2_max(self)
                \/ Line3_max(self) \/ Line3_max0(self) \/ Line3_max1(self)
                \/ Line3_max2(self) \/ Line3_max3(self)
                \/ return_label(self) \/ Line5_max(self) \/ Line6_max(self)
                \/ Line7_max(self) \/ Line8_max(self) \/ End_max(self)

Line0_main(self) == /\ pc[self] = "Line0_main"
                    /\ IF result_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ result_ptr_main' = [result_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - result_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ result_ptr_main' = [result_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line1_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main >>

Line1_main(self) == /\ pc[self] = "Line1_main"
                    /\ IF y_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ y_ptr_main' = [y_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - y_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ y_ptr_main' = [y_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line2_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    result_ptr_main >>

Line2_main(self) == /\ pc[self] = "Line2_main"
                    /\ IF x_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ x_ptr_main' = [x_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - x_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ x_ptr_main' = [x_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line3_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, y_ptr_main, 
                                    result_ptr_main >>

Line3_main(self) == /\ pc[self] = "Line3_main"
                    /\ LET seq == idx_seq(my_stack[self], x_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 5, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 5, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line4_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main, result_ptr_main >>

Line4_main(self) == /\ pc[self] = "Line4_main"
                    /\ LET seq == idx_seq(my_stack[self], y_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 10, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 10, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line5_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main, result_ptr_main >>

Line5_main(self) == /\ pc[self] = "Line5_main"
                    /\ /\ a_max' = [a_max EXCEPT ![self] = load(my_stack[self], x_ptr_main[self])]
                       /\ b_max' = [b_max EXCEPT ![self] = load(my_stack[self], y_ptr_main[self])]
                       /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "max",
                                                                pc        |->  "Line6_main",
                                                                a_ptr_max |->  a_ptr_max[self],
                                                                b_ptr_max |->  b_ptr_max[self],
                                                                __retres_ptr_max |->  __retres_ptr_max[self],
                                                                a_max     |->  a_max[self],
                                                                b_max     |->  b_max[self] ] >>
                                                            \o stack[self]]
                    /\ a_ptr_max' = [a_ptr_max EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ b_ptr_max' = [b_ptr_max EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ __retres_ptr_max' = [__retres_ptr_max EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ pc' = [pc EXCEPT ![self] = "Line0_max"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret, x_ptr_main, y_ptr_main, 
                                    result_ptr_main >>

Line6_main(self) == /\ pc[self] = "Line6_main"
                    /\ LET seq == idx_seq(my_stack[self], result_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (Head(ret[self])), Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, (Head(ret[self])), Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ ret' = [ret EXCEPT ![self] = Tail(ret[self])]
                    /\ pc' = [pc EXCEPT ![self] = "Line7_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main, result_ptr_main >>

Line7_main(self) == /\ pc[self] = "Line7_main"
                    /\ IF ((load(my_stack[self], result_ptr_main[self])>8))
                          THEN /\ pc' = [pc EXCEPT ![self] = "Line7_main0"]
                          ELSE /\ pc' = [pc EXCEPT ![self] = "Line7_main1"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, a_max, b_max, 
                                    a_ptr_max, b_ptr_max, __retres_ptr_max, 
                                    x_ptr_main, y_ptr_main, result_ptr_main >>

Line7_main0(self) == /\ pc[self] = "Line7_main0"
                     /\ LET seq == idx_seq(my_stack[self], result_ptr_main[self]) IN
                          IF seq[1] = "stack"
                             THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], ((load(my_stack[self], result_ptr_main[self])*2)), Tail(seq))]
                                  /\ mem' = mem
                             ELSE /\ mem' = update_stack(mem, ((load(my_stack[self], result_ptr_main[self])*2)), Tail(seq))
                                  /\ UNCHANGED my_stack
                     /\ pc' = [pc EXCEPT ![self] = "Line8_main"]
                     /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                     b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                     y_ptr_main, result_ptr_main >>

Line7_main1(self) == /\ pc[self] = "Line7_main1"
                     /\ TRUE
                     /\ pc' = [pc EXCEPT ![self] = "Line8_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, my_stack, ret, a_max, b_max, 
                                     a_ptr_max, b_ptr_max, __retres_ptr_max, 
                                     x_ptr_main, y_ptr_main, result_ptr_main >>

Line8_main(self) == /\ pc[self] = "Line8_main"
                    /\ ret' = [ret EXCEPT ![self] = <<(load(my_stack[self], result_ptr_main[self]))>> \o ret[self]]
                    /\ pc' = [pc EXCEPT ![self] = "Line9_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main, result_ptr_main >>

Line9_main(self) == /\ pc[self] = "Line9_main"
                    /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                    /\ pc' = [pc EXCEPT ![self] = "Line10_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                    y_ptr_main, result_ptr_main >>

Line10_main(self) == /\ pc[self] = "Line10_main"
                     /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                     /\ pc' = [pc EXCEPT ![self] = "Line11_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                     b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                     y_ptr_main, result_ptr_main >>

Line11_main(self) == /\ pc[self] = "Line11_main"
                     /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                     /\ pc' = [pc EXCEPT ![self] = "End_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, a_max, b_max, a_ptr_max, 
                                     b_ptr_max, __retres_ptr_max, x_ptr_main, 
                                     y_ptr_main, result_ptr_main >>

End_main(self) == /\ pc[self] = "End_main"
                  /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                  /\ x_ptr_main' = [x_ptr_main EXCEPT ![self] = Head(stack[self]).x_ptr_main]
                  /\ y_ptr_main' = [y_ptr_main EXCEPT ![self] = Head(stack[self]).y_ptr_main]
                  /\ result_ptr_main' = [result_ptr_main EXCEPT ![self] = Head(stack[self]).result_ptr_main]
                  /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                  /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                  my_stack, ret, a_max, b_max, a_ptr_max, 
                                  b_ptr_max, __retres_ptr_max >>

main(self) == Line0_main(self) \/ Line1_main(self) \/ Line2_main(self)
                 \/ Line3_main(self) \/ Line4_main(self)
                 \/ Line5_main(self) \/ Line6_main(self)
                 \/ Line7_main(self) \/ Line7_main0(self)
                 \/ Line7_main1(self) \/ Line8_main(self)
                 \/ Line9_main(self) \/ Line10_main(self)
                 \/ Line11_main(self) \/ End_main(self)

Line0_globalInit(self) == /\ pc[self] = "Line0_globalInit"
                          /\ initDone' = TRUE
                          /\ pc' = [pc EXCEPT ![self] = "Done"]
                          /\ UNCHANGED << mem, tmpArrayFill, stack, size, 
                                          arr_ptr, my_stack, ret, a_max, b_max, 
                                          a_ptr_max, b_ptr_max, 
                                          __retres_ptr_max, x_ptr_main, 
                                          y_ptr_main, result_ptr_main >>

globalInit(self) == Line0_globalInit(self)

Line0_proc(self) == /\ pc[self] = "Line0_proc"
                    /\ initDone = TRUE
                    /\ pc' = [pc EXCEPT ![self] = "Line1_proc"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, a_max, b_max, 
                                    a_ptr_max, b_ptr_max, __retres_ptr_max, 
                                    x_ptr_main, y_ptr_main, result_ptr_main >>

Line1_proc(self) == /\ pc[self] = "Line1_proc"
                    /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "main",
                                                             pc        |->  "Done",
                                                             x_ptr_main |->  x_ptr_main[self],
                                                             y_ptr_main |->  y_ptr_main[self],
                                                             result_ptr_main |->  result_ptr_main[self] ] >>
                                                         \o stack[self]]
                    /\ x_ptr_main' = [x_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ y_ptr_main' = [y_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ result_ptr_main' = [result_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ pc' = [pc EXCEPT ![self] = "Line0_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret, a_max, b_max, a_ptr_max, 
                                    b_ptr_max, __retres_ptr_max >>

proc(self) == Line0_proc(self) \/ Line1_proc(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in ProcSet:  \/ init_array(self) \/ stacks_init(self)
                               \/ max(self) \/ main(self))
           \/ (\E self \in GLOBAL_INIT: globalInit(self))
           \/ (\E self \in PROCESS: proc(self))
           \/ Terminating

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in GLOBAL_INIT : WF_vars(globalInit(self))
        /\ \A self \in PROCESS : WF_vars(proc(self)) /\ WF_vars(main(self)) /\ WF_vars(max(self))

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
=============================================================================
