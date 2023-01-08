Forked from llvm/llvm-project(15.0.6).

Add a new LLVM Pass "HelloNew" to generate DDG(Data Dependency Graph).

Usage:

`build/bin/opt -disable-output test.ll -passes=hellonew`

More details:

https://llvm.org/docs/WritingAnLLVMNewPMPass.html
