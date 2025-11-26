------------------------------ MODULE test_loops ------------------------------
EXTENDS Integers, FiniteSets, Sequences
CONSTANT GLOBAL_INIT,PROCESS,UNDEF

(*--algorithm test_loops
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

procedure main()
variables
    i_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    sum_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    j_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    k_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
begin
    Line0_main:
    decl(UNDEF,k_ptr_main);

    Line1_main:
    decl(UNDEF,j_ptr_main);

    Line2_main:
    decl(UNDEF,sum_ptr_main);

    Line3_main:
    decl(UNDEF,i_ptr_main);

    Line4_main:
    store(0, i_ptr_main);

    Line5_main:
    store(0, sum_ptr_main);

    Line6_main:
    while(TRUE) do
        Line6_main0:
        if((load(my_stack, i_ptr_main)<5)) then
            Line6_main00:
            skip;
        else
            Line6_main01:
            goto while_0_break;

        end if;

        Line6_main1:
        store((load(my_stack, sum_ptr_main)+load(my_stack, i_ptr_main)), sum_ptr_main);

        Line6_main2:
        store((load(my_stack, i_ptr_main)+1), i_ptr_main);

    end while;

    while_0_break:
    skip;

    Line7_main:
    store(0, j_ptr_main);

    Line8_main:
    while(TRUE) do
        Line8_main0:
        if((load(my_stack, j_ptr_main)<3)) then
            Line8_main00:
            skip;
        else
            Line8_main01:
            goto while_1_break;

        end if;

        Line8_main1:
        store((load(my_stack, sum_ptr_main)+load(my_stack, j_ptr_main)), sum_ptr_main);

        Line8_main2:
        store((load(my_stack, j_ptr_main)+1), j_ptr_main);

    end while;

    while_1_break:
    skip;

    Line9_main:
    store(0, k_ptr_main);

    Line10_main:
    while(TRUE) do
        Line10_main0:
        store((load(my_stack, k_ptr_main)+1), k_ptr_main);

        Line10_main1:
        if((load(my_stack, k_ptr_main)<2)) then
            Line10_main10:
            skip;
        else
            Line10_main11:
            goto while_1_break_0;

        end if;

    end while;

    while_1_break_0:
    skip;

    Line11_main:
    push(ret, load(my_stack, sum_ptr_main));

    Line12_main:
    pop(my_stack);

    Line13_main:
    pop(my_stack);

    Line14_main:
    pop(my_stack);

    Line15_main:
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
\* BEGIN TRANSLATION (chksum(pcal) = "4abca4e0" /\ chksum(tla) = "37990e99")
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

VARIABLES size, arr_ptr, my_stack, ret, i_ptr_main, sum_ptr_main, j_ptr_main, 
          k_ptr_main

vars == << mem, tmpArrayFill, initDone, pc, stack, size, arr_ptr, my_stack, 
           ret, i_ptr_main, sum_ptr_main, j_ptr_main, k_ptr_main >>

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
        (* Procedure main *)
        /\ i_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ sum_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ j_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ k_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
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
                   /\ UNCHANGED << initDone, stack, size, arr_ptr, ret, 
                                   i_ptr_main, sum_ptr_main, j_ptr_main, 
                                   k_ptr_main >>

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
                        /\ UNCHANGED << initDone, ret, i_ptr_main, 
                                        sum_ptr_main, j_ptr_main, k_ptr_main >>

init_array(self) == InitArray(self) \/ WhileInitArray(self)

InitStack(self) == /\ pc[self] = "InitStack"
                   /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                   /\ my_stack' = [my_stack EXCEPT ![self] = Head(stack[self]).my_stack]
                   /\ ret' = [ret EXCEPT ![self] = Head(stack[self]).ret]
                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                   i_ptr_main, sum_ptr_main, j_ptr_main, 
                                   k_ptr_main >>

stacks_init(self) == InitStack(self)

Line0_main(self) == /\ pc[self] = "Line0_main"
                    /\ IF k_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ k_ptr_main' = [k_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - k_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ k_ptr_main' = [k_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line1_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                    j_ptr_main >>

Line1_main(self) == /\ pc[self] = "Line1_main"
                    /\ IF j_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ j_ptr_main' = [j_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - j_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ j_ptr_main' = [j_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line2_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                    k_ptr_main >>

Line2_main(self) == /\ pc[self] = "Line2_main"
                    /\ IF sum_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ sum_ptr_main' = [sum_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - sum_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ sum_ptr_main' = [sum_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line3_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, i_ptr_main, j_ptr_main, 
                                    k_ptr_main >>

Line3_main(self) == /\ pc[self] = "Line3_main"
                    /\ IF i_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ i_ptr_main' = [i_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - i_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ i_ptr_main' = [i_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line4_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, sum_ptr_main, j_ptr_main, 
                                    k_ptr_main >>

Line4_main(self) == /\ pc[self] = "Line4_main"
                    /\ LET seq == idx_seq(my_stack[self], i_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 0, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 0, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line5_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                    j_ptr_main, k_ptr_main >>

Line5_main(self) == /\ pc[self] = "Line5_main"
                    /\ LET seq == idx_seq(my_stack[self], sum_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 0, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 0, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line6_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                    j_ptr_main, k_ptr_main >>

Line6_main(self) == /\ pc[self] = "Line6_main"
                    /\ pc' = [pc EXCEPT ![self] = "Line6_main0"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, i_ptr_main, 
                                    sum_ptr_main, j_ptr_main, k_ptr_main >>

Line6_main0(self) == /\ pc[self] = "Line6_main0"
                     /\ IF ((load(my_stack[self], i_ptr_main[self])<5))
                           THEN /\ pc' = [pc EXCEPT ![self] = "Line6_main00"]
                           ELSE /\ pc' = [pc EXCEPT ![self] = "Line6_main01"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, my_stack, ret, i_ptr_main, 
                                     sum_ptr_main, j_ptr_main, k_ptr_main >>

Line6_main00(self) == /\ pc[self] = "Line6_main00"
                      /\ TRUE
                      /\ pc' = [pc EXCEPT ![self] = "Line6_main1"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, my_stack, ret, i_ptr_main, 
                                      sum_ptr_main, j_ptr_main, k_ptr_main >>

Line6_main01(self) == /\ pc[self] = "Line6_main01"
                      /\ pc' = [pc EXCEPT ![self] = "while_0_break"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, my_stack, ret, i_ptr_main, 
                                      sum_ptr_main, j_ptr_main, k_ptr_main >>

Line6_main1(self) == /\ pc[self] = "Line6_main1"
                     /\ LET seq == idx_seq(my_stack[self], sum_ptr_main[self]) IN
                          IF seq[1] = "stack"
                             THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], ((load(my_stack[self], sum_ptr_main[self])+load(my_stack[self], i_ptr_main[self]))), Tail(seq))]
                                  /\ mem' = mem
                             ELSE /\ mem' = update_stack(mem, ((load(my_stack[self], sum_ptr_main[self])+load(my_stack[self], i_ptr_main[self]))), Tail(seq))
                                  /\ UNCHANGED my_stack
                     /\ pc' = [pc EXCEPT ![self] = "Line6_main2"]
                     /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

Line6_main2(self) == /\ pc[self] = "Line6_main2"
                     /\ LET seq == idx_seq(my_stack[self], i_ptr_main[self]) IN
                          IF seq[1] = "stack"
                             THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], ((load(my_stack[self], i_ptr_main[self])+1)), Tail(seq))]
                                  /\ mem' = mem
                             ELSE /\ mem' = update_stack(mem, ((load(my_stack[self], i_ptr_main[self])+1)), Tail(seq))
                                  /\ UNCHANGED my_stack
                     /\ pc' = [pc EXCEPT ![self] = "Line6_main"]
                     /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

while_0_break(self) == /\ pc[self] = "while_0_break"
                       /\ TRUE
                       /\ pc' = [pc EXCEPT ![self] = "Line7_main"]
                       /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                       size, arr_ptr, my_stack, ret, 
                                       i_ptr_main, sum_ptr_main, j_ptr_main, 
                                       k_ptr_main >>

Line7_main(self) == /\ pc[self] = "Line7_main"
                    /\ LET seq == idx_seq(my_stack[self], j_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 0, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 0, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line8_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                    j_ptr_main, k_ptr_main >>

Line8_main(self) == /\ pc[self] = "Line8_main"
                    /\ pc' = [pc EXCEPT ![self] = "Line8_main0"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, i_ptr_main, 
                                    sum_ptr_main, j_ptr_main, k_ptr_main >>

Line8_main0(self) == /\ pc[self] = "Line8_main0"
                     /\ IF ((load(my_stack[self], j_ptr_main[self])<3))
                           THEN /\ pc' = [pc EXCEPT ![self] = "Line8_main00"]
                           ELSE /\ pc' = [pc EXCEPT ![self] = "Line8_main01"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, my_stack, ret, i_ptr_main, 
                                     sum_ptr_main, j_ptr_main, k_ptr_main >>

Line8_main00(self) == /\ pc[self] = "Line8_main00"
                      /\ TRUE
                      /\ pc' = [pc EXCEPT ![self] = "Line8_main1"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, my_stack, ret, i_ptr_main, 
                                      sum_ptr_main, j_ptr_main, k_ptr_main >>

Line8_main01(self) == /\ pc[self] = "Line8_main01"
                      /\ pc' = [pc EXCEPT ![self] = "while_1_break"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, my_stack, ret, i_ptr_main, 
                                      sum_ptr_main, j_ptr_main, k_ptr_main >>

Line8_main1(self) == /\ pc[self] = "Line8_main1"
                     /\ LET seq == idx_seq(my_stack[self], sum_ptr_main[self]) IN
                          IF seq[1] = "stack"
                             THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], ((load(my_stack[self], sum_ptr_main[self])+load(my_stack[self], j_ptr_main[self]))), Tail(seq))]
                                  /\ mem' = mem
                             ELSE /\ mem' = update_stack(mem, ((load(my_stack[self], sum_ptr_main[self])+load(my_stack[self], j_ptr_main[self]))), Tail(seq))
                                  /\ UNCHANGED my_stack
                     /\ pc' = [pc EXCEPT ![self] = "Line8_main2"]
                     /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

Line8_main2(self) == /\ pc[self] = "Line8_main2"
                     /\ LET seq == idx_seq(my_stack[self], j_ptr_main[self]) IN
                          IF seq[1] = "stack"
                             THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], ((load(my_stack[self], j_ptr_main[self])+1)), Tail(seq))]
                                  /\ mem' = mem
                             ELSE /\ mem' = update_stack(mem, ((load(my_stack[self], j_ptr_main[self])+1)), Tail(seq))
                                  /\ UNCHANGED my_stack
                     /\ pc' = [pc EXCEPT ![self] = "Line8_main"]
                     /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

while_1_break(self) == /\ pc[self] = "while_1_break"
                       /\ TRUE
                       /\ pc' = [pc EXCEPT ![self] = "Line9_main"]
                       /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                       size, arr_ptr, my_stack, ret, 
                                       i_ptr_main, sum_ptr_main, j_ptr_main, 
                                       k_ptr_main >>

Line9_main(self) == /\ pc[self] = "Line9_main"
                    /\ LET seq == idx_seq(my_stack[self], k_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 0, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 0, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line10_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                    j_ptr_main, k_ptr_main >>

Line10_main(self) == /\ pc[self] = "Line10_main"
                     /\ pc' = [pc EXCEPT ![self] = "Line10_main0"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, my_stack, ret, i_ptr_main, 
                                     sum_ptr_main, j_ptr_main, k_ptr_main >>

Line10_main0(self) == /\ pc[self] = "Line10_main0"
                      /\ LET seq == idx_seq(my_stack[self], k_ptr_main[self]) IN
                           IF seq[1] = "stack"
                              THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], ((load(my_stack[self], k_ptr_main[self])+1)), Tail(seq))]
                                   /\ mem' = mem
                              ELSE /\ mem' = update_stack(mem, ((load(my_stack[self], k_ptr_main[self])+1)), Tail(seq))
                                   /\ UNCHANGED my_stack
                      /\ pc' = [pc EXCEPT ![self] = "Line10_main1"]
                      /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                      j_ptr_main, k_ptr_main >>

Line10_main1(self) == /\ pc[self] = "Line10_main1"
                      /\ IF ((load(my_stack[self], k_ptr_main[self])<2))
                            THEN /\ pc' = [pc EXCEPT ![self] = "Line10_main10"]
                            ELSE /\ pc' = [pc EXCEPT ![self] = "Line10_main11"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, my_stack, ret, i_ptr_main, 
                                      sum_ptr_main, j_ptr_main, k_ptr_main >>

Line10_main10(self) == /\ pc[self] = "Line10_main10"
                       /\ TRUE
                       /\ pc' = [pc EXCEPT ![self] = "Line10_main"]
                       /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                       size, arr_ptr, my_stack, ret, 
                                       i_ptr_main, sum_ptr_main, j_ptr_main, 
                                       k_ptr_main >>

Line10_main11(self) == /\ pc[self] = "Line10_main11"
                       /\ pc' = [pc EXCEPT ![self] = "while_1_break_0"]
                       /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                       size, arr_ptr, my_stack, ret, 
                                       i_ptr_main, sum_ptr_main, j_ptr_main, 
                                       k_ptr_main >>

while_1_break_0(self) == /\ pc[self] = "while_1_break_0"
                         /\ TRUE
                         /\ pc' = [pc EXCEPT ![self] = "Line11_main"]
                         /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                         size, arr_ptr, my_stack, ret, 
                                         i_ptr_main, sum_ptr_main, j_ptr_main, 
                                         k_ptr_main >>

Line11_main(self) == /\ pc[self] = "Line11_main"
                     /\ ret' = [ret EXCEPT ![self] = <<(load(my_stack[self], sum_ptr_main[self]))>> \o ret[self]]
                     /\ pc' = [pc EXCEPT ![self] = "Line12_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, my_stack, i_ptr_main, 
                                     sum_ptr_main, j_ptr_main, k_ptr_main >>

Line12_main(self) == /\ pc[self] = "Line12_main"
                     /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                     /\ pc' = [pc EXCEPT ![self] = "Line13_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

Line13_main(self) == /\ pc[self] = "Line13_main"
                     /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                     /\ pc' = [pc EXCEPT ![self] = "Line14_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

Line14_main(self) == /\ pc[self] = "Line14_main"
                     /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                     /\ pc' = [pc EXCEPT ![self] = "Line15_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

Line15_main(self) == /\ pc[self] = "Line15_main"
                     /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                     /\ pc' = [pc EXCEPT ![self] = "End_main"]
                     /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                     arr_ptr, ret, i_ptr_main, sum_ptr_main, 
                                     j_ptr_main, k_ptr_main >>

End_main(self) == /\ pc[self] = "End_main"
                  /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                  /\ i_ptr_main' = [i_ptr_main EXCEPT ![self] = Head(stack[self]).i_ptr_main]
                  /\ sum_ptr_main' = [sum_ptr_main EXCEPT ![self] = Head(stack[self]).sum_ptr_main]
                  /\ j_ptr_main' = [j_ptr_main EXCEPT ![self] = Head(stack[self]).j_ptr_main]
                  /\ k_ptr_main' = [k_ptr_main EXCEPT ![self] = Head(stack[self]).k_ptr_main]
                  /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                  /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                  my_stack, ret >>

main(self) == Line0_main(self) \/ Line1_main(self) \/ Line2_main(self)
                 \/ Line3_main(self) \/ Line4_main(self)
                 \/ Line5_main(self) \/ Line6_main(self)
                 \/ Line6_main0(self) \/ Line6_main00(self)
                 \/ Line6_main01(self) \/ Line6_main1(self)
                 \/ Line6_main2(self) \/ while_0_break(self)
                 \/ Line7_main(self) \/ Line8_main(self)
                 \/ Line8_main0(self) \/ Line8_main00(self)
                 \/ Line8_main01(self) \/ Line8_main1(self)
                 \/ Line8_main2(self) \/ while_1_break(self)
                 \/ Line9_main(self) \/ Line10_main(self)
                 \/ Line10_main0(self) \/ Line10_main1(self)
                 \/ Line10_main10(self) \/ Line10_main11(self)
                 \/ while_1_break_0(self) \/ Line11_main(self)
                 \/ Line12_main(self) \/ Line13_main(self)
                 \/ Line14_main(self) \/ Line15_main(self)
                 \/ End_main(self)

Line0_globalInit(self) == /\ pc[self] = "Line0_globalInit"
                          /\ initDone' = TRUE
                          /\ pc' = [pc EXCEPT ![self] = "Done"]
                          /\ UNCHANGED << mem, tmpArrayFill, stack, size, 
                                          arr_ptr, my_stack, ret, i_ptr_main, 
                                          sum_ptr_main, j_ptr_main, k_ptr_main >>

globalInit(self) == Line0_globalInit(self)

Line0_proc(self) == /\ pc[self] = "Line0_proc"
                    /\ initDone = TRUE
                    /\ pc' = [pc EXCEPT ![self] = "Line1_proc"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, i_ptr_main, 
                                    sum_ptr_main, j_ptr_main, k_ptr_main >>

Line1_proc(self) == /\ pc[self] = "Line1_proc"
                    /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "main",
                                                             pc        |->  "Done",
                                                             i_ptr_main |->  i_ptr_main[self],
                                                             sum_ptr_main |->  sum_ptr_main[self],
                                                             j_ptr_main |->  j_ptr_main[self],
                                                             k_ptr_main |->  k_ptr_main[self] ] >>
                                                         \o stack[self]]
                    /\ i_ptr_main' = [i_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ sum_ptr_main' = [sum_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ j_ptr_main' = [j_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ k_ptr_main' = [k_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ pc' = [pc EXCEPT ![self] = "Line0_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret >>

proc(self) == Line0_proc(self) \/ Line1_proc(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in ProcSet:  \/ init_array(self) \/ stacks_init(self)
                               \/ main(self))
           \/ (\E self \in GLOBAL_INIT: globalInit(self))
           \/ (\E self \in PROCESS: proc(self))
           \/ Terminating

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in GLOBAL_INIT : WF_vars(globalInit(self))
        /\ \A self \in PROCESS : WF_vars(proc(self)) /\ WF_vars(main(self))

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
=============================================================================
