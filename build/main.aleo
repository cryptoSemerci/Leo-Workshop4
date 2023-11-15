import multisig.aleo;
program token.aleo;




record token:
    owner as address.private;
    amount as u64.private;

struct MintArgs:
    receiver as address;
    amount as u64;


function mint:
    input r0 as multisig.aleo/ticket.record;
    input r1 as MintArgs.private;
    assert.eq r0.program_address aleo16l909ch9c9zujjlthk47knk72zq0r4wd7eveqm8ukgta6cfszsgs4nd7p4;
    assert.eq r0.function_id 1field;
    hash.bhp256 r1 into r2 as field;
    assert.eq r0.args_hash r2;
    call multisig.aleo/burn r0;
    cast r1.receiver r1.amount into r3 as token.record;
    output r3 as token.record;


function transfer:
    input r0 as token.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as token.record;
    cast r1 r2 into r5 as token.record;
    output r4 as token.record;
    output r5 as token.record;
