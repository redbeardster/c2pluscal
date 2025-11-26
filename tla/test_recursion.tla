------------------------------ MODULE test_recursion ------------------------------
EXTENDS Integers, FiniteSets, Sequences
CONSTANT GLOBAL_INIT,PROCESS,UNDEF

(*--algorithm test_recursion
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

procedure fibonacci(n_fibonacci)
variables
    n_ptr_fibonacci = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    tmp_ptr_fibonacci = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    tmp_0_ptr_fibonacci = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    __retres_ptr_fibonacci = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
begin
    Line0_fibonacci:
    decl(n_fibonacci,n_ptr_fibonacci);

    Line1_fibonacci:
    decl(UNDEF,__retres_ptr_fibonacci);

    Line2_fibonacci:
    decl(UNDEF,tmp_0_ptr_fibonacci);

    Line3_fibonacci:
    decl(UNDEF,tmp_ptr_fibonacci);

    Line4_fibonacci:
    if((load(my_stack, n_ptr_fibonacci)<=1)) then
        Line4_fibonacci0:
        store(load(my_stack, n_ptr_fibonacci), __retres_ptr_fibonacci);

        Line4_fibonacci1:
        goto return_label;

    else
        Line4_fibonacci2:
        skip;
    end if;

    Line5_fibonacci:
    call fibonacci((load(my_stack, n_ptr_fibonacci)-1));

    Line6_fibonacci:
    attr_return(ret, tmp_ptr_fibonacci);

    Line7_fibonacci:
    call fibonacci((load(my_stack, n_ptr_fibonacci)-2));

    Line8_fibonacci:
    attr_return(ret, tmp_0_ptr_fibonacci);

    Line9_fibonacci:
    store((load(my_stack, tmp_ptr_fibonacci)+load(my_stack, tmp_0_ptr_fibonacci)), __retres_ptr_fibonacci);

    return_label:
    skip;

    Line11_fibonacci:
    push(ret, load(my_stack, __retres_ptr_fibonacci));

    Line12_fibonacci:
    pop(my_stack);

    Line13_fibonacci:
    pop(my_stack);

    Line14_fibonacci:
    pop(my_stack);

    Line15_fibonacci:
    pop(my_stack);

    End_fibonacci:
    return;
end procedure;

procedure main()
variables
    result_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
begin
    Line0_main:
    decl(UNDEF,result_ptr_main);

    Line1_main:
    call fibonacci(5);

    Line2_main:
    attr_return(ret, result_ptr_main);

    Line3_main:
    push(ret, load(my_stack, result_ptr_main));

    Line4_main:
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
\* BEGIN TRANSLATION (chksum(pcal) = "123e6c7f" /\ chksum(tla) = "d8184f0a")
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

VARIABLES size, arr_ptr, my_stack, ret, n_fibonacci, n_ptr_fibonacci, 
          tmp_ptr_fibonacci, tmp_0_ptr_fibonacci, __retres_ptr_fibonacci, 
          result_ptr_main

vars == << mem, tmpArrayFill, initDone, pc, stack, size, arr_ptr, my_stack, 
           ret, n_fibonacci, n_ptr_fibonacci, tmp_ptr_fibonacci, 
           tmp_0_ptr_fibonacci, __retres_ptr_fibonacci, result_ptr_main >>

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
        (* Procedure fibonacci *)
        /\ n_fibonacci = [ self \in ProcSet |-> defaultInitValue]
        /\ n_ptr_fibonacci = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ tmp_ptr_fibonacci = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ tmp_0_ptr_fibonacci = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ __retres_ptr_fibonacci = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        (* Procedure main *)
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
                   /\ UNCHANGED << initDone, stack, size, arr_ptr, ret, 
                                   n_fibonacci, n_ptr_fibonacci, 
                                   tmp_ptr_fibonacci, tmp_0_ptr_fibonacci, 
                                   __retres_ptr_fibonacci, result_ptr_main >>

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
                        /\ UNCHANGED << initDone, ret, n_fibonacci, 
                                        n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                        tmp_0_ptr_fibonacci, 
                                        __retres_ptr_fibonacci, 
                                        result_ptr_main >>

init_array(self) == InitArray(self) \/ WhileInitArray(self)

InitStack(self) == /\ pc[self] = "InitStack"
                   /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                   /\ my_stack' = [my_stack EXCEPT ![self] = Head(stack[self]).my_stack]
                   /\ ret' = [ret EXCEPT ![self] = Head(stack[self]).ret]
                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                   n_fibonacci, n_ptr_fibonacci, 
                                   tmp_ptr_fibonacci, tmp_0_ptr_fibonacci, 
                                   __retres_ptr_fibonacci, result_ptr_main >>

stacks_init(self) == InitStack(self)

Line0_fibonacci(self) == /\ pc[self] = "Line0_fibonacci"
                         /\ IF n_ptr_fibonacci[self].loc = "stack"
                               THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<n_fibonacci[self]>> \o my_stack[self]]
                                    /\ n_ptr_fibonacci' = [n_ptr_fibonacci EXCEPT ![self].offs = Len(my_stack'[self]) - n_ptr_fibonacci[self].fp - 1]
                                    /\ mem' = mem
                               ELSE /\ mem' = <<n_fibonacci[self]>> \o mem
                                    /\ n_ptr_fibonacci' = [n_ptr_fibonacci EXCEPT ![self].offs = Len(mem') - 1]
                                    /\ UNCHANGED my_stack
                         /\ pc' = [pc EXCEPT ![self] = "Line1_fibonacci"]
                         /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                         arr_ptr, ret, n_fibonacci, 
                                         tmp_ptr_fibonacci, 
                                         tmp_0_ptr_fibonacci, 
                                         __retres_ptr_fibonacci, 
                                         result_ptr_main >>

Line1_fibonacci(self) == /\ pc[self] = "Line1_fibonacci"
                         /\ IF __retres_ptr_fibonacci[self].loc = "stack"
                               THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                                    /\ __retres_ptr_fibonacci' = [__retres_ptr_fibonacci EXCEPT ![self].offs = Len(my_stack'[self]) - __retres_ptr_fibonacci[self].fp - 1]
                                    /\ mem' = mem
                               ELSE /\ mem' = <<UNDEF>> \o mem
                                    /\ __retres_ptr_fibonacci' = [__retres_ptr_fibonacci EXCEPT ![self].offs = Len(mem') - 1]
                                    /\ UNCHANGED my_stack
                         /\ pc' = [pc EXCEPT ![self] = "Line2_fibonacci"]
                         /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                         arr_ptr, ret, n_fibonacci, 
                                         n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                         tmp_0_ptr_fibonacci, result_ptr_main >>

Line2_fibonacci(self) == /\ pc[self] = "Line2_fibonacci"
                         /\ IF tmp_0_ptr_fibonacci[self].loc = "stack"
                               THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                                    /\ tmp_0_ptr_fibonacci' = [tmp_0_ptr_fibonacci EXCEPT ![self].offs = Len(my_stack'[self]) - tmp_0_ptr_fibonacci[self].fp - 1]
                                    /\ mem' = mem
                               ELSE /\ mem' = <<UNDEF>> \o mem
                                    /\ tmp_0_ptr_fibonacci' = [tmp_0_ptr_fibonacci EXCEPT ![self].offs = Len(mem') - 1]
                                    /\ UNCHANGED my_stack
                         /\ pc' = [pc EXCEPT ![self] = "Line3_fibonacci"]
                         /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                         arr_ptr, ret, n_fibonacci, 
                                         n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                         __retres_ptr_fibonacci, 
                                         result_ptr_main >>

Line3_fibonacci(self) == /\ pc[self] = "Line3_fibonacci"
                         /\ IF tmp_ptr_fibonacci[self].loc = "stack"
                               THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                                    /\ tmp_ptr_fibonacci' = [tmp_ptr_fibonacci EXCEPT ![self].offs = Len(my_stack'[self]) - tmp_ptr_fibonacci[self].fp - 1]
                                    /\ mem' = mem
                               ELSE /\ mem' = <<UNDEF>> \o mem
                                    /\ tmp_ptr_fibonacci' = [tmp_ptr_fibonacci EXCEPT ![self].offs = Len(mem') - 1]
                                    /\ UNCHANGED my_stack
                         /\ pc' = [pc EXCEPT ![self] = "Line4_fibonacci"]
                         /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                         arr_ptr, ret, n_fibonacci, 
                                         n_ptr_fibonacci, tmp_0_ptr_fibonacci, 
                                         __retres_ptr_fibonacci, 
                                         result_ptr_main >>

Line4_fibonacci(self) == /\ pc[self] = "Line4_fibonacci"
                         /\ IF ((load(my_stack[self], n_ptr_fibonacci[self])<=1))
                               THEN /\ pc' = [pc EXCEPT ![self] = "Line4_fibonacci0"]
                               ELSE /\ pc' = [pc EXCEPT ![self] = "Line4_fibonacci2"]
                         /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                         size, arr_ptr, my_stack, ret, 
                                         n_fibonacci, n_ptr_fibonacci, 
                                         tmp_ptr_fibonacci, 
                                         tmp_0_ptr_fibonacci, 
                                         __retres_ptr_fibonacci, 
                                         result_ptr_main >>

Line4_fibonacci0(self) == /\ pc[self] = "Line4_fibonacci0"
                          /\ LET seq == idx_seq(my_stack[self], __retres_ptr_fibonacci[self]) IN
                               IF seq[1] = "stack"
                                  THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (load(my_stack[self], n_ptr_fibonacci[self])), Tail(seq))]
                                       /\ mem' = mem
                                  ELSE /\ mem' = update_stack(mem, (load(my_stack[self], n_ptr_fibonacci[self])), Tail(seq))
                                       /\ UNCHANGED my_stack
                          /\ pc' = [pc EXCEPT ![self] = "Line4_fibonacci1"]
                          /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                          arr_ptr, ret, n_fibonacci, 
                                          n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

Line4_fibonacci1(self) == /\ pc[self] = "Line4_fibonacci1"
                          /\ pc' = [pc EXCEPT ![self] = "return_label"]
                          /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                          size, arr_ptr, my_stack, ret, 
                                          n_fibonacci, n_ptr_fibonacci, 
                                          tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

Line4_fibonacci2(self) == /\ pc[self] = "Line4_fibonacci2"
                          /\ TRUE
                          /\ pc' = [pc EXCEPT ![self] = "Line5_fibonacci"]
                          /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                          size, arr_ptr, my_stack, ret, 
                                          n_fibonacci, n_ptr_fibonacci, 
                                          tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

Line5_fibonacci(self) == /\ pc[self] = "Line5_fibonacci"
                         /\ /\ n_fibonacci' = [n_fibonacci EXCEPT ![self] = (load(my_stack[self], n_ptr_fibonacci[self])-1)]
                            /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "fibonacci",
                                                                     pc        |->  "Line6_fibonacci",
                                                                     n_ptr_fibonacci |->  n_ptr_fibonacci[self],
                                                                     tmp_ptr_fibonacci |->  tmp_ptr_fibonacci[self],
                                                                     tmp_0_ptr_fibonacci |->  tmp_0_ptr_fibonacci[self],
                                                                     __retres_ptr_fibonacci |->  __retres_ptr_fibonacci[self],
                                                                     n_fibonacci |->  n_fibonacci[self] ] >>
                                                                 \o stack[self]]
                         /\ n_ptr_fibonacci' = [n_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ tmp_ptr_fibonacci' = [tmp_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ tmp_0_ptr_fibonacci' = [tmp_0_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ __retres_ptr_fibonacci' = [__retres_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ pc' = [pc EXCEPT ![self] = "Line0_fibonacci"]
                         /\ UNCHANGED << mem, tmpArrayFill, initDone, size, 
                                         arr_ptr, my_stack, ret, 
                                         result_ptr_main >>

Line6_fibonacci(self) == /\ pc[self] = "Line6_fibonacci"
                         /\ LET seq == idx_seq(my_stack[self], tmp_ptr_fibonacci[self]) IN
                              IF seq[1] = "stack"
                                 THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (Head(ret[self])), Tail(seq))]
                                      /\ mem' = mem
                                 ELSE /\ mem' = update_stack(mem, (Head(ret[self])), Tail(seq))
                                      /\ UNCHANGED my_stack
                         /\ ret' = [ret EXCEPT ![self] = Tail(ret[self])]
                         /\ pc' = [pc EXCEPT ![self] = "Line7_fibonacci"]
                         /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                         arr_ptr, n_fibonacci, n_ptr_fibonacci, 
                                         tmp_ptr_fibonacci, 
                                         tmp_0_ptr_fibonacci, 
                                         __retres_ptr_fibonacci, 
                                         result_ptr_main >>

Line7_fibonacci(self) == /\ pc[self] = "Line7_fibonacci"
                         /\ /\ n_fibonacci' = [n_fibonacci EXCEPT ![self] = (load(my_stack[self], n_ptr_fibonacci[self])-2)]
                            /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "fibonacci",
                                                                     pc        |->  "Line8_fibonacci",
                                                                     n_ptr_fibonacci |->  n_ptr_fibonacci[self],
                                                                     tmp_ptr_fibonacci |->  tmp_ptr_fibonacci[self],
                                                                     tmp_0_ptr_fibonacci |->  tmp_0_ptr_fibonacci[self],
                                                                     __retres_ptr_fibonacci |->  __retres_ptr_fibonacci[self],
                                                                     n_fibonacci |->  n_fibonacci[self] ] >>
                                                                 \o stack[self]]
                         /\ n_ptr_fibonacci' = [n_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ tmp_ptr_fibonacci' = [tmp_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ tmp_0_ptr_fibonacci' = [tmp_0_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ __retres_ptr_fibonacci' = [__retres_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                         /\ pc' = [pc EXCEPT ![self] = "Line0_fibonacci"]
                         /\ UNCHANGED << mem, tmpArrayFill, initDone, size, 
                                         arr_ptr, my_stack, ret, 
                                         result_ptr_main >>

Line8_fibonacci(self) == /\ pc[self] = "Line8_fibonacci"
                         /\ LET seq == idx_seq(my_stack[self], tmp_0_ptr_fibonacci[self]) IN
                              IF seq[1] = "stack"
                                 THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (Head(ret[self])), Tail(seq))]
                                      /\ mem' = mem
                                 ELSE /\ mem' = update_stack(mem, (Head(ret[self])), Tail(seq))
                                      /\ UNCHANGED my_stack
                         /\ ret' = [ret EXCEPT ![self] = Tail(ret[self])]
                         /\ pc' = [pc EXCEPT ![self] = "Line9_fibonacci"]
                         /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                         arr_ptr, n_fibonacci, n_ptr_fibonacci, 
                                         tmp_ptr_fibonacci, 
                                         tmp_0_ptr_fibonacci, 
                                         __retres_ptr_fibonacci, 
                                         result_ptr_main >>

Line9_fibonacci(self) == /\ pc[self] = "Line9_fibonacci"
                         /\ LET seq == idx_seq(my_stack[self], __retres_ptr_fibonacci[self]) IN
                              IF seq[1] = "stack"
                                 THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], ((load(my_stack[self], tmp_ptr_fibonacci[self])+load(my_stack[self], tmp_0_ptr_fibonacci[self]))), Tail(seq))]
                                      /\ mem' = mem
                                 ELSE /\ mem' = update_stack(mem, ((load(my_stack[self], tmp_ptr_fibonacci[self])+load(my_stack[self], tmp_0_ptr_fibonacci[self]))), Tail(seq))
                                      /\ UNCHANGED my_stack
                         /\ pc' = [pc EXCEPT ![self] = "return_label"]
                         /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                         arr_ptr, ret, n_fibonacci, 
                                         n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                         tmp_0_ptr_fibonacci, 
                                         __retres_ptr_fibonacci, 
                                         result_ptr_main >>

return_label(self) == /\ pc[self] = "return_label"
                      /\ TRUE
                      /\ pc' = [pc EXCEPT ![self] = "Line11_fibonacci"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, my_stack, ret, n_fibonacci, 
                                      n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                      tmp_0_ptr_fibonacci, 
                                      __retres_ptr_fibonacci, result_ptr_main >>

Line11_fibonacci(self) == /\ pc[self] = "Line11_fibonacci"
                          /\ ret' = [ret EXCEPT ![self] = <<(load(my_stack[self], __retres_ptr_fibonacci[self]))>> \o ret[self]]
                          /\ pc' = [pc EXCEPT ![self] = "Line12_fibonacci"]
                          /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                          size, arr_ptr, my_stack, n_fibonacci, 
                                          n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

Line12_fibonacci(self) == /\ pc[self] = "Line12_fibonacci"
                          /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                          /\ pc' = [pc EXCEPT ![self] = "Line13_fibonacci"]
                          /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                          size, arr_ptr, ret, n_fibonacci, 
                                          n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

Line13_fibonacci(self) == /\ pc[self] = "Line13_fibonacci"
                          /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                          /\ pc' = [pc EXCEPT ![self] = "Line14_fibonacci"]
                          /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                          size, arr_ptr, ret, n_fibonacci, 
                                          n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

Line14_fibonacci(self) == /\ pc[self] = "Line14_fibonacci"
                          /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                          /\ pc' = [pc EXCEPT ![self] = "Line15_fibonacci"]
                          /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                          size, arr_ptr, ret, n_fibonacci, 
                                          n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

Line15_fibonacci(self) == /\ pc[self] = "Line15_fibonacci"
                          /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                          /\ pc' = [pc EXCEPT ![self] = "End_fibonacci"]
                          /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, 
                                          size, arr_ptr, ret, n_fibonacci, 
                                          n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

End_fibonacci(self) == /\ pc[self] = "End_fibonacci"
                       /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                       /\ n_ptr_fibonacci' = [n_ptr_fibonacci EXCEPT ![self] = Head(stack[self]).n_ptr_fibonacci]
                       /\ tmp_ptr_fibonacci' = [tmp_ptr_fibonacci EXCEPT ![self] = Head(stack[self]).tmp_ptr_fibonacci]
                       /\ tmp_0_ptr_fibonacci' = [tmp_0_ptr_fibonacci EXCEPT ![self] = Head(stack[self]).tmp_0_ptr_fibonacci]
                       /\ __retres_ptr_fibonacci' = [__retres_ptr_fibonacci EXCEPT ![self] = Head(stack[self]).__retres_ptr_fibonacci]
                       /\ n_fibonacci' = [n_fibonacci EXCEPT ![self] = Head(stack[self]).n_fibonacci]
                       /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                       /\ UNCHANGED << mem, tmpArrayFill, initDone, size, 
                                       arr_ptr, my_stack, ret, result_ptr_main >>

fibonacci(self) == Line0_fibonacci(self) \/ Line1_fibonacci(self)
                      \/ Line2_fibonacci(self) \/ Line3_fibonacci(self)
                      \/ Line4_fibonacci(self) \/ Line4_fibonacci0(self)
                      \/ Line4_fibonacci1(self) \/ Line4_fibonacci2(self)
                      \/ Line5_fibonacci(self) \/ Line6_fibonacci(self)
                      \/ Line7_fibonacci(self) \/ Line8_fibonacci(self)
                      \/ Line9_fibonacci(self) \/ return_label(self)
                      \/ Line11_fibonacci(self) \/ Line12_fibonacci(self)
                      \/ Line13_fibonacci(self) \/ Line14_fibonacci(self)
                      \/ Line15_fibonacci(self) \/ End_fibonacci(self)

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
                                    arr_ptr, ret, n_fibonacci, n_ptr_fibonacci, 
                                    tmp_ptr_fibonacci, tmp_0_ptr_fibonacci, 
                                    __retres_ptr_fibonacci >>

Line1_main(self) == /\ pc[self] = "Line1_main"
                    /\ /\ n_fibonacci' = [n_fibonacci EXCEPT ![self] = 5]
                       /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "fibonacci",
                                                                pc        |->  "Line2_main",
                                                                n_ptr_fibonacci |->  n_ptr_fibonacci[self],
                                                                tmp_ptr_fibonacci |->  tmp_ptr_fibonacci[self],
                                                                tmp_0_ptr_fibonacci |->  tmp_0_ptr_fibonacci[self],
                                                                __retres_ptr_fibonacci |->  __retres_ptr_fibonacci[self],
                                                                n_fibonacci |->  n_fibonacci[self] ] >>
                                                            \o stack[self]]
                    /\ n_ptr_fibonacci' = [n_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ tmp_ptr_fibonacci' = [tmp_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ tmp_0_ptr_fibonacci' = [tmp_0_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ __retres_ptr_fibonacci' = [__retres_ptr_fibonacci EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ pc' = [pc EXCEPT ![self] = "Line0_fibonacci"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret, result_ptr_main >>

Line2_main(self) == /\ pc[self] = "Line2_main"
                    /\ LET seq == idx_seq(my_stack[self], result_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], (Head(ret[self])), Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, (Head(ret[self])), Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ ret' = [ret EXCEPT ![self] = Tail(ret[self])]
                    /\ pc' = [pc EXCEPT ![self] = "Line3_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, n_fibonacci, n_ptr_fibonacci, 
                                    tmp_ptr_fibonacci, tmp_0_ptr_fibonacci, 
                                    __retres_ptr_fibonacci, result_ptr_main >>

Line3_main(self) == /\ pc[self] = "Line3_main"
                    /\ ret' = [ret EXCEPT ![self] = <<(load(my_stack[self], result_ptr_main[self]))>> \o ret[self]]
                    /\ pc' = [pc EXCEPT ![self] = "Line4_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, n_fibonacci, 
                                    n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                    tmp_0_ptr_fibonacci, 
                                    __retres_ptr_fibonacci, result_ptr_main >>

Line4_main(self) == /\ pc[self] = "Line4_main"
                    /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                    /\ pc' = [pc EXCEPT ![self] = "End_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, n_fibonacci, n_ptr_fibonacci, 
                                    tmp_ptr_fibonacci, tmp_0_ptr_fibonacci, 
                                    __retres_ptr_fibonacci, result_ptr_main >>

End_main(self) == /\ pc[self] = "End_main"
                  /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                  /\ result_ptr_main' = [result_ptr_main EXCEPT ![self] = Head(stack[self]).result_ptr_main]
                  /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                  /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                  my_stack, ret, n_fibonacci, n_ptr_fibonacci, 
                                  tmp_ptr_fibonacci, tmp_0_ptr_fibonacci, 
                                  __retres_ptr_fibonacci >>

main(self) == Line0_main(self) \/ Line1_main(self) \/ Line2_main(self)
                 \/ Line3_main(self) \/ Line4_main(self) \/ End_main(self)

Line0_globalInit(self) == /\ pc[self] = "Line0_globalInit"
                          /\ initDone' = TRUE
                          /\ pc' = [pc EXCEPT ![self] = "Done"]
                          /\ UNCHANGED << mem, tmpArrayFill, stack, size, 
                                          arr_ptr, my_stack, ret, n_fibonacci, 
                                          n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                          tmp_0_ptr_fibonacci, 
                                          __retres_ptr_fibonacci, 
                                          result_ptr_main >>

globalInit(self) == Line0_globalInit(self)

Line0_proc(self) == /\ pc[self] = "Line0_proc"
                    /\ initDone = TRUE
                    /\ pc' = [pc EXCEPT ![self] = "Line1_proc"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, n_fibonacci, 
                                    n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                    tmp_0_ptr_fibonacci, 
                                    __retres_ptr_fibonacci, result_ptr_main >>

Line1_proc(self) == /\ pc[self] = "Line1_proc"
                    /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "main",
                                                             pc        |->  "Done",
                                                             result_ptr_main |->  result_ptr_main[self] ] >>
                                                         \o stack[self]]
                    /\ result_ptr_main' = [result_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ pc' = [pc EXCEPT ![self] = "Line0_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret, n_fibonacci, 
                                    n_ptr_fibonacci, tmp_ptr_fibonacci, 
                                    tmp_0_ptr_fibonacci, 
                                    __retres_ptr_fibonacci >>

proc(self) == Line0_proc(self) \/ Line1_proc(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in ProcSet:  \/ init_array(self) \/ stacks_init(self)
                               \/ fibonacci(self) \/ main(self))
           \/ (\E self \in GLOBAL_INIT: globalInit(self))
           \/ (\E self \in PROCESS: proc(self))
           \/ Terminating

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in GLOBAL_INIT : WF_vars(globalInit(self))
        /\ \A self \in PROCESS : WF_vars(proc(self)) /\ WF_vars(main(self)) /\ WF_vars(fibonacci(self))

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
=============================================================================
