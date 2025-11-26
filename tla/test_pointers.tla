------------------------------ MODULE test_pointers ------------------------------
EXTENDS Integers, FiniteSets, Sequences
CONSTANT GLOBAL_INIT,PROCESS,UNDEF

(*--algorithm test_pointers
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

procedure modify(ptr_modify)
variables
    ptr_ptr_modify = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
begin
    Line0_modify:
    decl(ptr_modify,ptr_ptr_modify);

    Line1_modify:
    store(42, load(my_stack,ptr_ptr_modify));

    Line2_modify:
    pop(my_stack);

    End_modify:
    return;
end procedure;

procedure main()
variables
    x_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
    p_ptr_main = [loc |-> "stack", fp |-> Len(my_stack), offs |-> 0];
begin
    Line0_main:
    decl(UNDEF,p_ptr_main);

    Line1_main:
    decl(UNDEF,x_ptr_main);

    Line2_main:
    store(10, x_ptr_main);

    Line3_main:
    store(x_ptr_main, p_ptr_main);

    Line4_main:
    store(20, load(my_stack,p_ptr_main));

    Line5_main:
    call modify(x_ptr_main);

    Line6_main:
    push(ret, load(my_stack, x_ptr_main));

    Line7_main:
    pop(my_stack);

    Line8_main:
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
\* BEGIN TRANSLATION (chksum(pcal) = "ec378823" /\ chksum(tla) = "ac80644")
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

VARIABLES size, arr_ptr, my_stack, ret, ptr_modify, ptr_ptr_modify, 
          x_ptr_main, p_ptr_main

vars == << mem, tmpArrayFill, initDone, pc, stack, size, arr_ptr, my_stack, 
           ret, ptr_modify, ptr_ptr_modify, x_ptr_main, p_ptr_main >>

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
        (* Procedure modify *)
        /\ ptr_modify = [ self \in ProcSet |-> defaultInitValue]
        /\ ptr_ptr_modify = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        (* Procedure main *)
        /\ x_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
        /\ p_ptr_main = [ self \in ProcSet |-> [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
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
                                   ptr_modify, ptr_ptr_modify, x_ptr_main, 
                                   p_ptr_main >>

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
                        /\ UNCHANGED << initDone, ret, ptr_modify, 
                                        ptr_ptr_modify, x_ptr_main, p_ptr_main >>

init_array(self) == InitArray(self) \/ WhileInitArray(self)

InitStack(self) == /\ pc[self] = "InitStack"
                   /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                   /\ my_stack' = [my_stack EXCEPT ![self] = Head(stack[self]).my_stack]
                   /\ ret' = [ret EXCEPT ![self] = Head(stack[self]).ret]
                   /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                   /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                   ptr_modify, ptr_ptr_modify, x_ptr_main, 
                                   p_ptr_main >>

stacks_init(self) == InitStack(self)

Line0_modify(self) == /\ pc[self] = "Line0_modify"
                      /\ IF ptr_ptr_modify[self].loc = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<ptr_modify[self]>> \o my_stack[self]]
                                 /\ ptr_ptr_modify' = [ptr_ptr_modify EXCEPT ![self].offs = Len(my_stack'[self]) - ptr_ptr_modify[self].fp - 1]
                                 /\ mem' = mem
                            ELSE /\ mem' = <<ptr_modify[self]>> \o mem
                                 /\ ptr_ptr_modify' = [ptr_ptr_modify EXCEPT ![self].offs = Len(mem') - 1]
                                 /\ UNCHANGED my_stack
                      /\ pc' = [pc EXCEPT ![self] = "Line1_modify"]
                      /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, ret, ptr_modify, x_ptr_main, 
                                      p_ptr_main >>

Line1_modify(self) == /\ pc[self] = "Line1_modify"
                      /\ LET seq == idx_seq(my_stack[self], (load(my_stack[self],ptr_ptr_modify[self]))) IN
                           IF seq[1] = "stack"
                              THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 42, Tail(seq))]
                                   /\ mem' = mem
                              ELSE /\ mem' = update_stack(mem, 42, Tail(seq))
                                   /\ UNCHANGED my_stack
                      /\ pc' = [pc EXCEPT ![self] = "Line2_modify"]
                      /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                      x_ptr_main, p_ptr_main >>

Line2_modify(self) == /\ pc[self] = "Line2_modify"
                      /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                      /\ pc' = [pc EXCEPT ![self] = "End_modify"]
                      /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                      arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                      x_ptr_main, p_ptr_main >>

End_modify(self) == /\ pc[self] = "End_modify"
                    /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                    /\ ptr_ptr_modify' = [ptr_ptr_modify EXCEPT ![self] = Head(stack[self]).ptr_ptr_modify]
                    /\ ptr_modify' = [ptr_modify EXCEPT ![self] = Head(stack[self]).ptr_modify]
                    /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret, x_ptr_main, p_ptr_main >>

modify(self) == Line0_modify(self) \/ Line1_modify(self)
                   \/ Line2_modify(self) \/ End_modify(self)

Line0_main(self) == /\ pc[self] = "Line0_main"
                    /\ IF p_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ p_ptr_main' = [p_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - p_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ p_ptr_main' = [p_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line1_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                    x_ptr_main >>

Line1_main(self) == /\ pc[self] = "Line1_main"
                    /\ IF x_ptr_main[self].loc = "stack"
                          THEN /\ my_stack' = [my_stack EXCEPT ![self] = <<UNDEF>> \o my_stack[self]]
                               /\ x_ptr_main' = [x_ptr_main EXCEPT ![self].offs = Len(my_stack'[self]) - x_ptr_main[self].fp - 1]
                               /\ mem' = mem
                          ELSE /\ mem' = <<UNDEF>> \o mem
                               /\ x_ptr_main' = [x_ptr_main EXCEPT ![self].offs = Len(mem') - 1]
                               /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line2_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                    p_ptr_main >>

Line2_main(self) == /\ pc[self] = "Line2_main"
                    /\ LET seq == idx_seq(my_stack[self], x_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 10, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 10, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line3_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                    x_ptr_main, p_ptr_main >>

Line3_main(self) == /\ pc[self] = "Line3_main"
                    /\ LET seq == idx_seq(my_stack[self], p_ptr_main[self]) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], x_ptr_main[self], Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, x_ptr_main[self], Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line4_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                    x_ptr_main, p_ptr_main >>

Line4_main(self) == /\ pc[self] = "Line4_main"
                    /\ LET seq == idx_seq(my_stack[self], (load(my_stack[self],p_ptr_main[self]))) IN
                         IF seq[1] = "stack"
                            THEN /\ my_stack' = [my_stack EXCEPT ![self] = update_stack(my_stack[self], 20, Tail(seq))]
                                 /\ mem' = mem
                            ELSE /\ mem' = update_stack(mem, 20, Tail(seq))
                                 /\ UNCHANGED my_stack
                    /\ pc' = [pc EXCEPT ![self] = "Line5_main"]
                    /\ UNCHANGED << tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                    x_ptr_main, p_ptr_main >>

Line5_main(self) == /\ pc[self] = "Line5_main"
                    /\ /\ ptr_modify' = [ptr_modify EXCEPT ![self] = x_ptr_main[self]]
                       /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "modify",
                                                                pc        |->  "Line6_main",
                                                                ptr_ptr_modify |->  ptr_ptr_modify[self],
                                                                ptr_modify |->  ptr_modify[self] ] >>
                                                            \o stack[self]]
                    /\ ptr_ptr_modify' = [ptr_ptr_modify EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ pc' = [pc EXCEPT ![self] = "Line0_modify"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret, x_ptr_main, p_ptr_main >>

Line6_main(self) == /\ pc[self] = "Line6_main"
                    /\ ret' = [ret EXCEPT ![self] = <<(load(my_stack[self], x_ptr_main[self]))>> \o ret[self]]
                    /\ pc' = [pc EXCEPT ![self] = "Line7_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ptr_modify, 
                                    ptr_ptr_modify, x_ptr_main, p_ptr_main >>

Line7_main(self) == /\ pc[self] = "Line7_main"
                    /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                    /\ pc' = [pc EXCEPT ![self] = "Line8_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                    x_ptr_main, p_ptr_main >>

Line8_main(self) == /\ pc[self] = "Line8_main"
                    /\ my_stack' = [my_stack EXCEPT ![self] = Tail(my_stack[self])]
                    /\ pc' = [pc EXCEPT ![self] = "End_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, ret, ptr_modify, ptr_ptr_modify, 
                                    x_ptr_main, p_ptr_main >>

End_main(self) == /\ pc[self] = "End_main"
                  /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                  /\ x_ptr_main' = [x_ptr_main EXCEPT ![self] = Head(stack[self]).x_ptr_main]
                  /\ p_ptr_main' = [p_ptr_main EXCEPT ![self] = Head(stack[self]).p_ptr_main]
                  /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                  /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                  my_stack, ret, ptr_modify, ptr_ptr_modify >>

main(self) == Line0_main(self) \/ Line1_main(self) \/ Line2_main(self)
                 \/ Line3_main(self) \/ Line4_main(self)
                 \/ Line5_main(self) \/ Line6_main(self)
                 \/ Line7_main(self) \/ Line8_main(self) \/ End_main(self)

Line0_globalInit(self) == /\ pc[self] = "Line0_globalInit"
                          /\ initDone' = TRUE
                          /\ pc' = [pc EXCEPT ![self] = "Done"]
                          /\ UNCHANGED << mem, tmpArrayFill, stack, size, 
                                          arr_ptr, my_stack, ret, ptr_modify, 
                                          ptr_ptr_modify, x_ptr_main, 
                                          p_ptr_main >>

globalInit(self) == Line0_globalInit(self)

Line0_proc(self) == /\ pc[self] = "Line0_proc"
                    /\ initDone = TRUE
                    /\ pc' = [pc EXCEPT ![self] = "Line1_proc"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, stack, size, 
                                    arr_ptr, my_stack, ret, ptr_modify, 
                                    ptr_ptr_modify, x_ptr_main, p_ptr_main >>

Line1_proc(self) == /\ pc[self] = "Line1_proc"
                    /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "main",
                                                             pc        |->  "Done",
                                                             x_ptr_main |->  x_ptr_main[self],
                                                             p_ptr_main |->  p_ptr_main[self] ] >>
                                                         \o stack[self]]
                    /\ x_ptr_main' = [x_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ p_ptr_main' = [p_ptr_main EXCEPT ![self] = [loc |-> "stack", fp |-> Len(my_stack[self]), offs |-> 0]]
                    /\ pc' = [pc EXCEPT ![self] = "Line0_main"]
                    /\ UNCHANGED << mem, tmpArrayFill, initDone, size, arr_ptr, 
                                    my_stack, ret, ptr_modify, ptr_ptr_modify >>

proc(self) == Line0_proc(self) \/ Line1_proc(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in ProcSet:  \/ init_array(self) \/ stacks_init(self)
                               \/ modify(self) \/ main(self))
           \/ (\E self \in GLOBAL_INIT: globalInit(self))
           \/ (\E self \in PROCESS: proc(self))
           \/ Terminating

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in GLOBAL_INIT : WF_vars(globalInit(self))
        /\ \A self \in PROCESS : WF_vars(proc(self)) /\ WF_vars(main(self)) /\ WF_vars(modify(self))

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
=============================================================================
