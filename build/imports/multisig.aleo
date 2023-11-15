program multisig.aleo;

struct Proposal:
    program_address as address;
    function_id as field;
    args_hash as field;

struct Sign:
    proposal as Proposal;
    signer as address;

record ticket:
    owner as address.private;
    program_address as address.private;
    function_id as field.private;
    args_hash as field.private;


mapping required_signatures:
	key as boolean.public;
	value as u64.public;


mapping proposals:
	key as Proposal.public;
	value as u64.public;


mapping signers:
	key as address.public;
	value as boolean.public;


mapping all_signatures:
	key as Sign.public;
	value as boolean.public;

function mint_ticket:
    input r0 as Proposal.private;
    cast self.caller r0.program_address r0.function_id r0.args_hash into r1 as ticket.record;
    async mint_ticket r0 into r2;
    output r1 as ticket.record;
    output r2 as multisig.aleo/mint_ticket.future;

finalize mint_ticket:
    input r0 as Proposal.public;
    get.or_use proposals[r0] 0u64 into r1;
    get.or_use required_signatures[true] 0u64 into r2;
    gte r1 r2 into r3;
    assert.eq r3 true;
    set 0u64 into proposals[r0];


function sign:
    input r0 as Proposal.private;
    async sign self.caller r0 into r1;
    output r1 as multisig.aleo/sign.future;

finalize sign:
    input r0 as address.public;
    input r1 as Proposal.public;
    cast r1 r0 into r2 as Sign;
    get.or_use all_signatures[r2] true into r3;
    get signers[r0] into r4;
    not r3 into r5;
    or r5 r4 into r6;
    assert.eq r6 true;
    get.or_use proposals[r1] 0u64 into r7;
    add r7 1u64 into r8;
    set r8 into proposals[r1];
    set false into all_signatures[r2];


function add_signer:
    input r0 as ticket.record;
    input r1 as address.private;
    assert.eq r0.program_address aleo10frku8hz8zyyh03avmr2gjg6zyqz98g2fmcew96a50vxeke995qsuf90f2;
    assert.eq r0.function_id 1field;
    hash.bhp256 r1 into r2 as field;
    assert.eq r0.args_hash r2;
    async add_signer r1 into r3;
    output r3 as multisig.aleo/add_signer.future;

finalize add_signer:
    input r0 as address.public;
    set true into signers[r0];


function change_required_signatures:
    input r0 as ticket.record;
    input r1 as u64.private;
    assert.eq r0.program_address aleo10frku8hz8zyyh03avmr2gjg6zyqz98g2fmcew96a50vxeke995qsuf90f2;
    assert.eq r0.function_id 2field;
    hash.bhp256 r1 into r2 as field;
    assert.eq r0.args_hash r2;
    async change_required_signatures r1 into r3;
    output r3 as multisig.aleo/change_required_signatures.future;

finalize change_required_signatures:
    input r0 as u64.public;
    set r0 into required_signatures[true];


function burn:
    input r0 as ticket.record;
