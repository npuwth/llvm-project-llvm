#include "llvm/Transforms/Utils/HelloNew.h"
#include <llvm/IR/CFG.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Constants.h>

using namespace llvm;

/*std::string HelloNewPass::changeIns2Str(Instruction *ins) {
    std::string temp_str;
    raw_string_ostream os(temp_str);
    ins->print(os);
    return os.str();
}*/

bool stringStartWith(std::string str, std::string s)
{
	if(s.length() > str.length())
		return false;
	return str.substr(0,s.length()) == s;
}

//����Ǳ������ñ��������֣������ָ������ָ�������
std::string HelloNewPass::getValueName(Value *v) {
	if(value2name.find(v) != value2name.end())
		return value2name[v];

    std::string temp_result = "val";
    
	if(v->getName().empty()) 
	{
		if(llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(v)) 
		{
			temp_result = "num:" + std::to_string(CI->getSExtValue());
		}
		else
		{
			temp_result += std::to_string(num);
			num++;
		}
        
    } 
    else {
        temp_result = v->getName().str();
    }
	value2name[v] = temp_result;
    //StringRef result(temp_result);
    //errs() << result;
    return temp_result;
}


int HelloNewPass::node::totalId = 0;
HelloNewPass::node* HelloNewPass::getNode(Value* v, Instruction* inst)
{
	HelloNewPass::node* temp = NULL;
	
	if(dyn_cast<llvm::ConstantInt>(v))
	{
		temp = new HelloNewPass::node(v, getValueName(v));
		this->value2node[v] = temp;
		nodes.push_back(temp);
		HelloNewPass::node::totalId++;
		temp->id = HelloNewPass::node::totalId;
	}
	/*else if(LoadInst *linst = dyn_cast<LoadInst>(v))
	{
		temp = new HelloNewPass::node(v, getValueName(v));
		//this->value2node[v] = temp;
		nodes.push_back(temp);
		HelloNewPass::node::totalId++;
		temp->id = HelloNewPass::node::totalId;
	}
	else if(StoreInst *sinst = dyn_cast<StoreInst>(v))
	{
		temp = new HelloNewPass::node(v, getValueName(v));
		//this->value2node[v] = temp;
		nodes.push_back(temp);
		HelloNewPass::node::totalId++;
		temp->id = HelloNewPass::node::totalId;
	}*/
	else if(this->value2node.find(v) != this->value2node.end())
		temp = this->value2node[v];
	else
	{
		temp = new HelloNewPass::node(v, getValueName(v));
		this->value2node[v] = temp;
		nodes.push_back(temp);
		HelloNewPass::node::totalId++;
		temp->id = HelloNewPass::node::totalId;
	}
	
	
	if(inst)
	{
		temp->opcode = inst->getOpcode();
		temp->opcodeName = inst->getOpcodeName();
	}
	
	return temp;
}

void HelloNewPass::linkNode(node* s, node* e)
{
	if(std::find(s->successors.begin(),s->successors.end(), e) == s->successors.end())
		s->successors.push_back(e);
	if(std::find(e->predecessors.begin(),e->predecessors.end(), s) == e->predecessors.end())
		e->predecessors.push_back(s);
}

HelloNewPass::edge* HelloNewPass::getEdge(HelloNewPass::node* s, HelloNewPass::node* e)
{
	HelloNewPass::edge* temp = new edge(s,e);
	
	return temp;
}

void HelloNewPass::calculateEdge()
{
	releaseEdge();
	std::vector<node*>::iterator iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if(n->successors.empty() && n->predecessors.empty())
		{
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			for(long unsigned int i = 0; i < n->successors.size(); i++)
			{
				edges.push_back(getEdge(n, n->successors[i]));
			}
			iter2++;
		}
			

		
	}

}


void HelloNewPass::releaseNode()
{
	std::vector<node*>::iterator iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();iter2++)
	{
		delete *iter2;
	}
	nodes.clear();
	value2node.clear();
}


void HelloNewPass::releaseEdge()
{
	std::vector<edge*>::iterator iter = edges.begin();
	for(;iter !=  edges.end();iter++)
	{
		delete *iter;
	}
	edges.clear();
}





void HelloNewPass::simplify()
{
	std::vector<node*>::iterator iter2;

	//���getelementptrǰ������ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "getelementptr")
		{
			
			for(long unsigned int j = 0; j < n->predecessors.size(); j++)
			{
				node* pr = n->predecessors[j];
				
				if(!(pr->valueName.length()>4 && pr->valueName.substr(0,4)=="num:") &&
					!(pr->opcodeName=="sext"))
				{
					pr->isArray = true;
					break;
				}
			}
		}
		iter2++;
		
		
	}

	
	//���⴦���洢����Ԫ�ص�store�ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();iter2++)
	{
		node* n = *iter2;
		if (n->opcodeName == "store")
		{
			std::vector<node*>::iterator iter3 = nodes.begin();
			for(;iter3 !=  nodes.end();iter3++)
			{
				node* n2 = *iter3;
				if(n2 != n && n2->opcodeName == "getelementptr" && n->valueName == n2->valueName)
				{
					n->opcodeName = "AryEleStore";
				}
			}

		}
	}
	
	//�Ƴ�stroe�ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "store")
		{
			n->predecessors[0]->valueName = n->valueName;
			n->predecessors[0]->successors.erase(
				std::find(
					n->predecessors[0]->successors.begin(),
					n->predecessors[0]->successors.end(),
					n)
			);
			for(long unsigned int i = 0;i<n->successors.size();i++)
			{
				node* su = n->successors[i];
				for(long unsigned int j = 0;j<su->predecessors.size();j++)
				{
					if(su->predecessors[j] == n)
					{
						su->predecessors[j] = n->predecessors[0];
						n->predecessors[0]->successors.push_back(su);
					}
				}
			}
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			iter2++;
		}
	}
	
	//�Ƴ�load�ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "load")
		{
			n->predecessors[0]->successors.erase(
				std::find(
					n->predecessors[0]->successors.begin(),
					n->predecessors[0]->successors.end(),
					n)
			);
			for(long unsigned int i = 0;i<n->successors.size();i++)
			{
				node* su = n->successors[i];
				for(long unsigned int j = 0;j<su->predecessors.size();j++)
				{
					if(su->predecessors[j] == n)
					{
						su->predecessors[j] = n->predecessors[0];
						n->predecessors[0]->successors.push_back(su);
					}
				}
			}
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			iter2++;
		}
	}
	
	
	//�Ƴ�sext�ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "sext")
		{
			n->predecessors[0]->successors.erase(
				std::find(
					n->predecessors[0]->successors.begin(),
					n->predecessors[0]->successors.end(),
					n)
			);
			for(long unsigned int i = 0;i<n->successors.size();i++)
			{
				node* su = n->successors[i];
				for(long unsigned int j = 0;j<su->predecessors.size();j++)
				{
					if(su->predecessors[j] == n)
					{
						su->predecessors[j] = n->predecessors[0];
						n->predecessors[0]->successors.push_back(su);
					}
				}
			}
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			iter2++;
		}
	}
	
	//�Ƴ�getelementptrǰ��num:0�ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "" && n->valueName=="num:0" && 
			n->successors.size() == 1 && n->successors[0]->opcodeName=="getelementptr"
			 && n->successors[0]->predecessors.size() == 3)
		{
			node* su = n->successors[0];
			for(long unsigned int j = 0;j<su->predecessors.size();j++)
			{
				if(su->predecessors[j] == n)
				{
					su->predecessors.erase(su->predecessors.begin() + j);
					break;
				}
			}
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			iter2++;
		}
	}
	
	
    //����getelementptr�ı�����Ϊ������+��������
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "getelementptr" && n->predecessors.size() == 2)
		{
			std::string arrayName = "";
			std::string indexName = "";
			node* indexNode = NULL;
			for(long unsigned int j = 0;j<n->predecessors.size();j++)
			{
				node* pr = n->predecessors[j];
				if(pr->isArray)
				{
					arrayName = pr->valueName;
				}
				else
				{
					
					indexName = pr->valueName;
					if(indexName.length()>4 && indexName.substr(0,4) == "num:")
						indexName = indexName.substr(4,indexName.length()-4);
					indexNode = pr;
				}
			}
			

			std::vector<node*>::iterator iter3 = nodes.begin();
			for(;iter3 !=  nodes.end();iter3++)
			{
				node* n2 = *iter3;
				if(n2 != n && n->valueName == n2->valueName)
				{
					n2->valueName = arrayName + "[" + indexName + "]";
					n2->arrayName = arrayName;
					n2->indexName = indexName;
					n2->indexNode = indexNode;
				}
			}

			n->valueName = arrayName + "[" + indexName + "]";
			n->arrayName = arrayName;
			n->indexName = indexName;
			n->indexNode = indexNode;
		}
		iter2++;
	}

	

	
	//�Ƴ�����ǰ����������
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "getelementptr" && n->predecessors.size() == 2)
		{
			std::vector<node*>::iterator iter3 = n->predecessors.begin();
			for(;iter3!=n->predecessors.end();)
			{
				node* pr = *iter3;
				if(pr->isArray)
				{
					iter3 = n->predecessors.erase(iter3);
					pr->successors.erase(
						std::find(
							pr->successors.begin(),
							pr->successors.end(),
							n
						));
				}
				else
				{
					iter3++;
				}
				
			}
			
		}
		iter2++;
	}
	
	

	
	//��������Ԫ��
	node* curAryEleStore = NULL;
	iter2 = nodes.begin();
	std::vector<node*> deleteNodes;
	for(long unsigned int i = 0;i<nodes.size();i++)
	{
		node* n = nodes[i];
		if (n->opcodeName == "AryEleStore")
		{
			curAryEleStore = n;

			for(long unsigned int j = i+1;j<nodes.size();j++)
			{
				node* nj = nodes[j];
				if(nj->opcodeName == "AryEleStore" && nj->valueName == n->valueName)
				{
					break;
				}
				//if(nj->opcodeName == "getelementptr" && nj->indexName == nj->successors[0]->valueName && nj->successors[0]->opcodeName!="")
				//{
				//
				//	break;
				//}
				if(nj->opcodeName == "getelementptr" &&
					nj->valueName == curAryEleStore->valueName &&
					(
						(
							curAryEleStore->indexNode == nj->indexNode
						)
						||
						(
							stringStartWith(curAryEleStore->indexNode->valueName,"num:") &&
							stringStartWith(nj->indexNode->valueName,"num:") &&
							nj->indexNode->valueName == curAryEleStore->indexNode->valueName
						)
					) &&
					nj->successors.size() > 0)
				{
					curAryEleStore->successors.push_back(nj->successors[0]);
					nj->successors[0]->predecessors.push_back(curAryEleStore);
					if(std::find(deleteNodes.begin(),deleteNodes.end(),nj) == deleteNodes.end())
						deleteNodes.push_back(nj);
				
				}
			}
		}
	}
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if(std::find(deleteNodes.begin(),deleteNodes.end(),*iter2) != deleteNodes.end())
		{
			n->predecessors[0]->successors.erase(
				std::find(
					n->predecessors[0]->successors.begin(),
					n->predecessors[0]->successors.end(),
					n)
			);
			for(long unsigned int i = 0;i<n->successors.size();i++)
			{
				node* su = n->successors[i];
				for(long unsigned int j = 0;j<su->predecessors.size();j++)
				{
					if(su->predecessors[j] == n)
					{
						su->predecessors.erase(su->predecessors.begin() + j);
						break;
					}
				}
			}
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			iter2++;
		}
	}
	deleteNodes.clear();
	
	
	//�Ƴ�AryEleStore�ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "AryEleStore")
		{
			n->predecessors[0]->valueName = n->valueName;
			n->predecessors[0]->successors.erase(
				std::find(
					n->predecessors[0]->successors.begin(),
					n->predecessors[0]->successors.end(),
					n)
			);
			for(long unsigned int i = 0;i<n->successors.size();i++)
			{
				node* su = n->successors[i];
				for(long unsigned int j = 0;j<su->predecessors.size();j++)
				{
					if(su->predecessors[j] == n)
					{
						su->predecessors[j] = n->predecessors[0];
						n->predecessors[0]->successors.push_back(su);
					}
				}
			}
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			iter2++;
		}
	}
	
	
	//ȥ���޺�̽ڵ��getelementptr�ڵ�
	int deleteCount = 0;
	while(1)
	{
		deleteCount = 0;
		iter2 = nodes.begin();
		for(;iter2 !=  nodes.end();)
		{
			node* n = *iter2;
			if (n->opcodeName == "getelementptr" && n->successors.size() == 0)
			{
			
				for(long unsigned int j = 0;j<n->predecessors.size();j++)
				{
					node* pr = n->predecessors[j];
				
					std::vector<node*>::iterator iter3 = pr->successors.begin();
					for(;iter3!=pr->successors.end();)
					{
						if(*iter3 == n)
						{
							iter3 = pr->successors.erase(iter3);
						}
						else
						{
							iter3++;
						}
					}
				}
				n->successors.clear();
				iter2 = nodes.erase(iter2);
				deleteCount++;
			}
			else
			{
				iter2++;
			}
		
		}
		if(deleteCount==0)
			break;
	}
	

	/*//�Ƴ�getelementptr�ڵ�
	iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();)
	{
		node* n = *iter2;
		if (n->opcodeName == "getelementptr")
		{
			n->predecessors[0]->successors.erase(
				std::find(
					n->predecessors[0]->successors.begin(),
					n->predecessors[0]->successors.end(),
					n)
			);
			for(int i = 0;i<n->successors.size();i++)
			{
				node* su = n->successors[i];
				for(int j = 0;j<su->predecessors.size();j++)
				{
					if(su->predecessors[j] == n)
					{
						su->predecessors[j] = n->predecessors[0];
						n->predecessors[0]->successors.push_back(su);
					}
				}
			}
			n->successors.clear();
			iter2 = nodes.erase(iter2);
		}
		else
		{
			iter2++;
		}
	}*/

	calculateEdge();
}


PreservedAnalyses HelloNewPass::run(Function &F, FunctionAnalysisManager &AM) {
    // errs() << "Function: " << F.getName() << "\n";                     //��ʾ��������
    // errs() << "num_function=" << num_function << "\n"; // num_function=0
    num_function++;
	
    //���������е�basicblock
    int num_BB = 0;
    for (Function::iterator BB = F.begin(); BB != F.end(); ++BB) 
    {
        // errs() << "block size:BB->size() " << BB->size() << "\n"; 

        num_BB++;
        BasicBlock *curBB = &*BB;
        
		std::string fileName = F.getName().str() + "BB" + std::to_string(num_BB);

		// if(fileName != "testFunc2BB3") // This function is the key point!!! filter the target function and target basicblock we want.
		// 	continue;

		errs() << fileName << "\n";

        for (BasicBlock::iterator II = curBB->begin(), IEnd = curBB->end(); II != IEnd; ++II) 
        {
            Instruction *curII = &*II;
            // errs() << getValueName(curII);
			// errs() << "\t" << curII->getOpcodeName() << "\n";
			
            switch (curII->getOpcode()) {
            //����load��store���ڴ���в�������Ҫ��loadָ���stroeָ������д���
                case llvm::Instruction::Load: {
                    LoadInst *linst = dyn_cast<LoadInst>(curII);
                    Value *loadValPtr = linst->getPointerOperand();
                    //edges.push_back(
                        linkNode(
                            getNode(loadValPtr,NULL),
                            getNode(curII, curII)
                        );
                    //);
					//this->value2node.erase(this->value2node.find(loadValPtr));

                    break;
                }
                case llvm::Instruction::Store: {
                    StoreInst *sinst = dyn_cast<StoreInst>(curII);
                    Value *storeValPtr = sinst->getPointerOperand();
                    Value *storeVal = sinst->getValueOperand();
					if(this->value2node.find(storeValPtr) != this->value2node.end())
						this->value2node.erase(this->value2node.find(storeValPtr));

					
					/*edges.push_back(
						new edge(
							getValueNode(storeVal ,curII),
							getValueNode(curII, curII)
						)
					);*/
                    //edges.push_back(
						linkNode(
							getNode(storeVal, NULL),
							getNode(storeValPtr, curII)
						);
					//);
                    break;
                }
				case llvm::Instruction::Alloca: {
                    for (Instruction::op_iterator op = curII->op_begin(), opEnd = curII->op_end(); op != opEnd; ++op) 
                    {
                        if (dyn_cast<Instruction>(*op)) 
						{
                            //edges.push_back(
								linkNode(
									getNode(op->get(), NULL),
									getNode(curII, curII)
								);
							//);
                        }
                    }
                    break;
                }
                default: {
                    for (Instruction::op_iterator op = curII->op_begin(), opEnd = curII->op_end(); op != opEnd; ++op) 
                    {
                        //if (dyn_cast<Instruction>(*op)) 
						{
                            //edges.push_back(
								linkNode(
									getNode(op->get(), NULL),
									getNode(curII, curII)
								);
							//);
                        }
                    }
                    break;
                }
            }
            
        }
        calculateEdge();
		
		// printBasicBlockNodesGraph(fileName); // debug
		
		outputBasicBlockNodesGraph(fileName, false);

		simplify();

		outputBasicBlockNodesGraph(fileName, true);

		calculateSubgraph();

        num = 0;
		value2name.clear();
		node::totalId = 0;
		releaseNode();
		releaseEdge();
        releaseSubgraph();
    }
    return PreservedAnalyses::all();
}

void HelloNewPass::printBasicBlockNodesGraph(std::string fileName)
{
	errs() << "digraph \"DFG for'" << fileName << + "\' \" {\n";
        
		errs() << "\t\n";

		for (std::vector<edge*>::iterator edge = edges.begin(), edge_end = edges.end(); edge != edge_end; ++edge) 
        {
            errs() << "\t" <<  (*edge)->s->valueName << "\t -> " << (*edge)->e->valueName <<  "(" + (*edge)->e->opcodeName +")\n";
		}

        errs() << "}\n\n";
        errs() << "Done\n\n\n";
}

void HelloNewPass::outputBasicBlockNodesGraph(std::string fileName, bool isSimple)
{
	if(isSimple)
		fileName = fileName + "AfterSimplify";
	std::ofstream dotfile;
	dotfile.open ("graphviz-test/" + fileName + ".dot");
	dotfile << "digraph \"DFG for'" << fileName << + "\' \" {\n";
		
	std::vector<node*>::iterator iter2 = nodes.begin();
	for(;iter2 !=  nodes.end();iter2++)
	{
		node* n = (*iter2);
		std::string str;
		if(n->opcodeName.empty())
		{
			str += "label=\"";
			str += std::to_string(n->id) + ":";
			str +=  n->valueName +  "\" ";
			str += "shape=plaintext ";
		}
		else
		{
			str += "label=\"";
			str += std::to_string(n->id) + ":";
			str += n->opcodeName + "(" + n->valueName + ")\" ";
		}

		dotfile << "\t" << n->id << "["+str+"]\n";
	}
	std::vector<edge*>::iterator iter = edges.begin();
	for(;iter !=  edges.end();iter++)
	{
		edge* ed = (*iter);
		dotfile << "\t" << ed->s->id << "->" << ed->e->id << ";\n";
	}
	dotfile << "}\n";
	dotfile.close();
		

	std::string cmd = "dot -Tpng graphviz-test/" + fileName + ".dot" + " -o graphviz-test/" + fileName +".png";
	if(system(cmd.c_str()) == -1) {
		errs() << "Error: Cannot convert dot to png.\n";
	}
}

bool llvm::cmpNode(HelloNewPass::node* a,HelloNewPass::node* b)
{
	return (a->id<b->id);
}

HelloNewPass::node* HelloNewPass::findNodeById(int id)
{
	for(long unsigned int i = 0;i<nodes.size();i++)
	{
		if(nodes[i]->id == id)
			return nodes[i];
	}
	return NULL;
}

//���ڼ���ͬ����������ͼ

void HelloNewPass::releaseSubgraph() 
{ 
	node2nodeIndependent.clear();
	allSameSubgraphs.clear();
	layers.clear();
}


void HelloNewPass::calculateSubgraph()
{
	topologicalSort();

	findSameSubgraph();
}

void HelloNewPass::topologicalSort() 
{
	std::vector<node*>::iterator iter = nodes.begin();
	for(;iter!=nodes.end();iter++)
	{
		node* n = *iter;
		n->inCount = n->predecessors.size();
		n->depth = -1;
	}
	int count = 0;
	int curDepth = 0;
	while(1)
	{
		count = 0;
		iter = nodes.begin();
		for(;iter!=nodes.end();iter++)
		{
			node* n = *iter;
			if(n->depth ==-2)
				n->depth = -1;
		}
		iter = nodes.begin();
		for(;iter!=nodes.end();iter++)
		{
			node* n = *iter;
			if(n->depth == -1 && n->inCount == 0)
			{
				n->depth = curDepth;
				layers[curDepth].push_back(n);
				for(long unsigned int i = 0;i<n->successors.size();i++)
				{
					n->successors[i]->inCount--;
					n->successors[i]->depth = -2;
				}
				count++;
			}
		}
		curDepth++;
		if(count == 0)
		{
			break;
		}
	}
}


void HelloNewPass::findSameSubgraph()
{
	//�ҳ�ͼ�����еĽڵ�����
	std::set<std::string> nodeOpcodes;
	std::map<std::string, std::vector<node*>> opcode2nodes;
	for(long unsigned int l = 0;l<layers.size();l++)
	{
		for(long unsigned int i = 0;i<layers[l].size();i++)
		{
			if(isCalculateNode(layers[l][i]))
			{
				nodeOpcodes.insert(layers[l][i]->opcodeName);
				opcode2nodes[layers[l][i]->opcodeName].push_back(layers[l][i]);
			}
		}
	}

	//���ÿ�ֽڵ����ͣ��ҳ�ȫ����ͬ����ͼ����
	std::set<std::string>::iterator itNodeOpcodes = nodeOpcodes.begin();
	for(;itNodeOpcodes != nodeOpcodes.end();itNodeOpcodes++)
	{
		std::string opcode = *itNodeOpcodes;
		//���ÿ�ֽڵ����ͣ��ҳ�ȫ���ĵ����ڵ��ͬ����ͼ����
		std::vector<SameSubgraph> sameSubgraphsForOneOpcode;
		std::vector<std::vector<node*>> allCombinationOfNodes;
		int opcodeNodeCount = opcode2nodes[opcode].size();
		//�ֱ�Ѱ���������ͼ���������ͼ���������
		for(int sameSubgraphCount = 2;sameSubgraphCount<=4 && sameSubgraphCount<=opcodeNodeCount;sameSubgraphCount++)
		{

			std::vector<std::vector<long unsigned int>> comb = getCombination(opcodeNodeCount, sameSubgraphCount);
			for(long unsigned int i = 0;i<comb.size();i++)
			{
				std::vector<node*> combinationOfNodes;
				for(long unsigned int j = 0;j<comb[i].size();j++)
				{
					int id = comb[i][j]-1;
					combinationOfNodes.push_back(opcode2nodes[opcode][id]);
				}
				if(areNodesAllIndependent(combinationOfNodes))
					allCombinationOfNodes.push_back(combinationOfNodes);
			}
		}

		//errs() << "Opcode: " << opcode << "\n";

		//�����ʼ�ĵ����ڵ��ͬ����ͼ
		for(long unsigned int i = 0;i<allCombinationOfNodes.size();i++)
		{
			SameSubgraph sameSubgraphForOneCombination;
			int graphCount = allCombinationOfNodes[i].size();
			sameSubgraphForOneCombination.nodeCountForSubgraph = graphCount;
			

			//���ù������ڵ�Ϊmask����������ͼ������չ�Ĺ��̾�������Щmask�ڵ���
			//errs() << "mask: ";
			std::vector<node*> commonParentNodes = getCommonParentNodes(allCombinationOfNodes[i]);
			for(long unsigned int j = 0;j<commonParentNodes.size();j++)
			{
				sameSubgraphForOneCombination.mask[commonParentNodes[j]] = true;
				//errs() << commonParentNodes[j]->id << " ";
			}
			//���������ڵ���mask
			for (int j = 0; j < graphCount; j++)
			{
				node* n = allCombinationOfNodes[i][j];
				sameSubgraphForOneCombination.mask[n] = true;
			}
			//errs() << "\n";

			//errs() << "nodes: ";

			//����ͬ����ͼ�е�������ͼ
			for(int j = 0;j< graphCount;j++)
			{
				node* n = allCombinationOfNodes[i][j];
				//errs() << n->id << " ";
				Subgraph subgraphForOneNode;
				subgraphForOneNode._graph[0].push_back(n);
				subgraphForOneNode.minDepth = n->depth;
				subgraphForOneNode.maxDepth = n->depth;

				//���ÿ���չ�Ľڵ�Ϊ��ǰ�ڵ��ǰ���ͺ�̵ļ���
				for (long unsigned int k = 0; k < n->predecessors.size(); k++)
				{
					if(sameSubgraphForOneCombination.mask.find(n->predecessors[k]) == sameSubgraphForOneCombination.mask.end() &&
						isCalculateNode(n->predecessors[k]))
						subgraphForOneNode.nodesCanExtend.insert(n->predecessors[k]);
				}
				for (long unsigned int k = 0; k < n->successors.size(); k++)
				{
					if (sameSubgraphForOneCombination.mask.find(n->successors[k]) == sameSubgraphForOneCombination.mask.end() &&
						isCalculateNode(n->successors[k]))
						subgraphForOneNode.nodesCanExtend.insert(n->successors[k]);
				}
				sameSubgraphForOneCombination.subgraphs.push_back(subgraphForOneNode);
			}
			//errs() << "\n";
			allSameSubgraphs[opcode].push_back(sameSubgraphForOneCombination);

		}

		//errs() << "Opcode: " << opcode << "\n";
		//for(int i = 0;i<allCombinationOfNodes.size();i++)
		//{
		//	for(int j = 0;j<allCombinationOfNodes[i].size();j++)
		//	{
		//		errs() << allCombinationOfNodes[i][j]->id << " ";
		//	}
		//	errs() <<"\n";
		//}

	}

	std::map<std::string, std::vector<SameSubgraph>>::iterator itAllSameSubgraphs = allSameSubgraphs.begin();
	for (; itAllSameSubgraphs != allSameSubgraphs.end(); itAllSameSubgraphs++)
	{
		//errs() << "===== opcode: " <<itAllSameSubgraphs->first << " =====\n";
		
		for (long unsigned int i = 0; i < itAllSameSubgraphs->second.size(); i++)
		{
			//errs() << "graph nodes: \n";
			//for (int graphId = 0; graphId < itAllSameSubgraphs->second[i].subgraphs.size(); graphId++)
			//{
			//	errs() << itAllSameSubgraphs->second[i].subgraphs[graphId].graph[0][0]->id << " ";
			//}
			//errs() << "\n";
			//errs() << "extend:\n";
			extendSameSubgraph(itAllSameSubgraphs->second[i]);
		}
	}


	//���ҵ���������ͼ��ռ�нڵ�������ͬ����ͼ��ȡ���
	itAllSameSubgraphs = allSameSubgraphs.begin();
	int maxCount = 0;
	SameSubgraph* biggestSameSubgraph = NULL;
	for(;itAllSameSubgraphs != allSameSubgraphs.end();itAllSameSubgraphs++)
	{
		for(long unsigned int i = 0;i<itAllSameSubgraphs->second.size();i++)
		{
			if(itAllSameSubgraphs->second[i].nodeCountForSubgraph > maxCount)
			{
				biggestSameSubgraph = &itAllSameSubgraphs->second[i];
				maxCount = itAllSameSubgraphs->second[i].nodeCountForSubgraph;
			}
		}
	}

	//������ͬ����ͼ���
	if(biggestSameSubgraph!=NULL)
	{
		errs() << "Find Same Subgraph!  node count: " << biggestSameSubgraph->nodeCountForSubgraph << "\n";
		errs() << "\n";
		for(long unsigned int s = 0;s<biggestSameSubgraph->subgraphs.size();s++)
		{
			errs() << "graph "<<std::to_string(s+1)<<" :\n";
			for(long unsigned int l = 0;l<biggestSameSubgraph->subgraphs[s]._graph.size();l++)
			{
				for(long unsigned int i = 0;i<biggestSameSubgraph->subgraphs[s]._graph[l].size();i++)
				{
					node* n = biggestSameSubgraph->subgraphs[s]._graph[l][i];
					errs() << n->id << " ";
				}
				errs() << "\n";
			}
		}
	}
	


	//testAreTwoSubgraphIndependent1();
	//testAreTwoSubgraphIndependent2();
}

//������չһ����ͼ
void HelloNewPass::extendSameSubgraph(SameSubgraph& sameSubgraph)
{
	bool extended = false;
	while (1)
	{
		extended = extendSameSubgraphOnce(sameSubgraph);

		if (extended == false)
		{
			break;
		}
	}
}

//������չ�򷵻�true��û��չ�򷵻�false
bool HelloNewPass::extendSameSubgraphOnce(SameSubgraph& sameSubgraph)
{
	bool extended = false;
	
	//�����κ�һ����ͼû�п���չ�Ľڵ��򷵻�false����ʾͬ����ͼ������չ
	bool noNodesCanExtend = false;
	for (long unsigned int i = 0; i < sameSubgraph.subgraphs.size(); i++)
	{
		if (sameSubgraph.subgraphs[i].nodesCanExtend.empty())
		{
			noNodesCanExtend = true;
			break;
		}
	}
	if (noNodesCanExtend)
	{
		return false;
	}

	
	int graphCount = sameSubgraph.subgraphs.size();


	std::vector <std::vector<node*>> nodesCanExtendForSubgraphs;

	std::vector<node*> nodesExtendForEachSubgraph;
	std::vector<int> extendEachConditionCount;
	std::vector<int> extendEachConditionIndex;
	int extendAllConditionCount = 1;
	for (int graphId = 0; graphId < graphCount; graphId++)
	{
		nodesExtendForEachSubgraph.push_back(NULL);
		extendEachConditionCount.push_back(sameSubgraph.subgraphs[graphId].nodesCanExtend.size());
		if(graphId == graphCount - 1)
			extendEachConditionIndex.push_back(-1);
		else
			extendEachConditionIndex.push_back(0);

		extendAllConditionCount *= sameSubgraph.subgraphs[graphId].nodesCanExtend.size();

		std::vector<node*> nodesCanExtendForOneSubgraph;
		std::set<node*>::iterator itSubgraphICanExtend;
		for (itSubgraphICanExtend = sameSubgraph.subgraphs[graphId].nodesCanExtend.begin();
			itSubgraphICanExtend != sameSubgraph.subgraphs[graphId].nodesCanExtend.end();
			itSubgraphICanExtend++)
		{
			nodesCanExtendForOneSubgraph.push_back(*itSubgraphICanExtend);
		}
		nodesCanExtendForSubgraphs.push_back(nodesCanExtendForOneSubgraph);
	}
	//errs() << "extend:\n";
	for (int i = 0; i < extendAllConditionCount; i++)
	{
		int plusOne = true;
		for (int j = graphCount - 1; j >= 0 && plusOne; j--)
		{
			plusOne = false;
			extendEachConditionIndex[j] ++;
			if (extendEachConditionIndex[j] >= extendEachConditionCount[j])
			{
				extendEachConditionIndex[j] = 0;
				plusOne = true;
			}
			else
			{
				break;
			}
		}

		//�ж��Ƿ���ͬ����ͬ�ṹ��һ��ڵ㣬ֻ�����������ͼ����һ����չ
		bool nodesSame = true;
		nodesExtendForEachSubgraph[0] = nodesCanExtendForSubgraphs[0][extendEachConditionIndex[0]];
		for (int i = 1; i < graphCount; i++)
		{
			nodesExtendForEachSubgraph[i] = nodesCanExtendForSubgraphs[i][extendEachConditionIndex[i]];
			if (!areTwoNodeSame(nodesExtendForEachSubgraph[i], nodesExtendForEachSubgraph[i - 1]))
			{
				nodesSame = false;
				break;
			}
		}

		if (nodesSame)
		{
			//������չ����ڵ�
			if (extendSameSubgraphOnceOneNode(sameSubgraph, nodesExtendForEachSubgraph))
			{

				//for (int i = 0; i < graphCount; i++)
				//{
				//	errs() << nodesExtendForEachSubgraph[i]->id << " ";
				//}
				//errs() << "\n";

				extended = true;
				break;
			}
		}
		
	}
	//errs() << "--------\n";

	
	return extended;
}

bool HelloNewPass::extendSameSubgraphOnceOneNode(SameSubgraph& sameSubgraph, std::vector<node*>& nodesExtendForEachSubgraph)
{
	//�ж�Ҫ����չ�Ľڵ���Ե�ǰͼ����С��ȵĲ�ֵ��ֻ�и���Ҫ��չ�Ľڵ����Ȳ�ֵһ�²��ܶ�����ڵ������չ
	int graphCount = sameSubgraph.subgraphs.size();

	int deltaDepth = sameSubgraph.subgraphs[0].minDepth - nodesExtendForEachSubgraph[0]->depth;
	int currentLayersCount = sameSubgraph.subgraphs[0].maxDepth - sameSubgraph.subgraphs[0].minDepth + 1;
	for (int i = 1; i < graphCount; i++)
	{
		if (sameSubgraph.subgraphs[i].minDepth - nodesExtendForEachSubgraph[i]->depth != deltaDepth)
		{
			return false;
		}
	}

	//����һ���µ���ͼ
	std::vector<graph> subgraphsTest;
	for (int i = 0; i < graphCount; i++)
	{
		graph subgraphTest;
		
		if (deltaDepth > 0)//��Ҫ��չ�Ľڵ�����С��Ŀǰ��ͼ�е���С���
		{
			subgraphTest[0].push_back(nodesExtendForEachSubgraph[i]);
			//Ϊ��֤ͼ�������ԣ���Ȳ����1�Ļ���Ҫ��ͼ�м����յĲ�
			for (int l = 1; l < deltaDepth; l++)
			{
				subgraphTest[l].clear();
			}
			for (int l = deltaDepth; l < deltaDepth + currentLayersCount; l++)
			{
				subgraphTest[l] = sameSubgraph.subgraphs[i]._graph[l - deltaDepth];
			}
		}
		else if (-deltaDepth + 1 > currentLayersCount)//��Ҫ��չ�Ľڵ����ȴ���Ŀǰ��ͼ�е�������
		{
			for (int l = 0; l < currentLayersCount; l++)
			{
				subgraphTest[l] = sameSubgraph.subgraphs[i]._graph[l];
			}
			//Ϊ��֤ͼ�������ԣ���Ȳ����1�Ļ���Ҫ��ͼ�м����յĲ�
			for (int l = currentLayersCount; l < -deltaDepth; l++)
			{
				subgraphTest[l].clear();
			}
			subgraphTest[-deltaDepth].push_back(nodesExtendForEachSubgraph[i]);

		}
		else//��Ҫ��չ�Ľڵ�������Ŀǰ��ͼ�е���С��Ⱥ�������֮��
		{
			for (int l = 0; l < currentLayersCount; l++)
			{
				subgraphTest[l] = sameSubgraph.subgraphs[i]._graph[l];
			}
			subgraphTest[-deltaDepth].push_back(nodesExtendForEachSubgraph[i]);
		}
		subgraphsTest.push_back(subgraphTest);
	}

	//�ж������µ���ͼ�Ƿ�������
	if (!areSubgraphsAllIndependent(subgraphsTest))
	{
		return false;
	}
	//�ж������µ���ͼ�Ƿ�ͬ��
	for (int i = 1; i < graphCount; i++)
	{
		if (!areTwoSubgraphSame(subgraphsTest[0], subgraphsTest[i]))
		{
			return false;
		}
	}


	//����ǰ����жϣ�ִ�е�����ͱ�ʾ������չ��Щ�ڵ���

	//���ӵ�ǰ������ͼ�Ľڵ�����
	sameSubgraph.nodeCountForSubgraph += graphCount;
	for (int i = 0; i < graphCount; i++)
	{
		node* n = nodesExtendForEachSubgraph[i];

		//��������չ����Щ�ڵ���mask
		sameSubgraph.mask[n] = true;
		
		//�����µ���ͼ����
		sameSubgraph.subgraphs[i]._graph = subgraphsTest[i];

		//��������ͼ���
		if (deltaDepth > 0)
		{
			sameSubgraph.subgraphs[i].minDepth -= deltaDepth;
		}
		else if (-deltaDepth + 1 > currentLayersCount)
		{
			sameSubgraph.subgraphs[i].maxDepth += (-deltaDepth + 1 - currentLayersCount);
		}

		//�ڿ���չ�б��������ǰ����չ�ĵ�
		sameSubgraph.subgraphs[i].nodesCanExtend.erase(sameSubgraph.subgraphs[i].nodesCanExtend.find(n));
		
		//����ǰ����չ�ĵ��ǰ���ͺ�̼��뵽����չ�б���
		for (long unsigned int k = 0; k < n->predecessors.size(); k++)
		{
			if (sameSubgraph.mask.find(n->predecessors[k]) == sameSubgraph.mask.end() &&
				isCalculateNode(n->predecessors[k]))
				sameSubgraph.subgraphs[i].nodesCanExtend.insert(n->predecessors[k]);
		}
		for (long unsigned int k = 0; k < n->successors.size(); k++)
		{
			if (sameSubgraph.mask.find(n->successors[k]) == sameSubgraph.mask.end() &&
				isCalculateNode(n->successors[k]))
				sameSubgraph.subgraphs[i].nodesCanExtend.insert(n->successors[k]);
		}
	}

	return true;
}


bool HelloNewPass::isCalculateNode(node* node)
{
	if(node->opcodeName != "" && 
		node->opcodeName != "getelementptr" && 
		node->opcodeName != "br")
	{
		return true;
	}
	return false;
}

std::vector<HelloNewPass::node*> HelloNewPass::getCommonParentNodes(std::vector<node*>& nodes)
{
	std::vector<node*> ret;
	std::unordered_map<node*, int> parentCountForCildren;//��¼ÿ���ڵ��Ƕ��ٸ�����������ͼ�Ľڵ�ĸ��ڵ㣬����1��������mask
	for(long unsigned int j = 0;j<nodes.size();j++)
	{
		node* n = nodes[j];
		std::unordered_map<node*, bool> node2flag;
	
		std::queue<node*> q;
		q.push(n);
		while(!q.empty())
		{
			node* px=q.front();
			q.pop();
			if(parentCountForCildren.find(px) == parentCountForCildren.end())
			{
				parentCountForCildren[px] = 0;
			}
			parentCountForCildren[px]++;

			for(long unsigned int pp = 0;pp<px->predecessors.size();pp++)
			{
				node* ppn = px->predecessors[pp];
				if(node2flag.find(ppn)==node2flag.end())
				{
					q.push(ppn);
					node2flag[ppn] = true;
				}
			}					
		}


	}
	//errs() << "masks: ";

	//����parentCountForCildren����1�Ľڵ�mask
	std::unordered_map<node*, int>::iterator itParentCountForCildren = parentCountForCildren.begin();
	for(;itParentCountForCildren != parentCountForCildren.end(); itParentCountForCildren++)
	{
		if(itParentCountForCildren->second > 1)
		{
			//errs() << itParentCountForCildren->first->id << " ";
			ret.push_back(itParentCountForCildren->first);
		}
	}
	//errs() << "\n";
	return ret;
}

void HelloNewPass::testAreTwoSubgraphIndependent1()
{
	std::vector<node*> O1layer;
	O1layer.push_back(findNodeById(8));

	std::vector<node*> O2layer;
	O2layer.push_back(findNodeById(37));
	O2layer.push_back(findNodeById(26));

	std::vector<node*> O3layer;
	O3layer.push_back(findNodeById(49));
	O3layer.push_back(findNodeById(61));
	
	std::vector<node*> O4layer;
	O4layer.push_back(findNodeById(78));

	std::vector<node*> T1layer;
	T1layer.push_back(findNodeById(93));

	std::vector<node*> T2layer;
	T2layer.push_back(findNodeById(110));
	T2layer.push_back(findNodeById(121));

	std::vector<node*> T3layer;
	T3layer.push_back(findNodeById(133));
	T3layer.push_back(findNodeById(145));
	
	std::vector<node*> T4layer;
	T4layer.push_back(findNodeById(162));

	graph Ograph;
	Ograph[0] = O1layer;
	Ograph[1] = O2layer;
	Ograph[2] = O3layer;
	Ograph[3] = O4layer;

	graph Tgraph;
	Tgraph[0] = T1layer;
	Tgraph[1] = T2layer;
	Tgraph[2] = T3layer;
	Tgraph[3] = T4layer;

	//Ӧ�÷���True
	errs() <<"IsGraphIndependent: "<< areTwoSubgraphIndependent(Ograph, Tgraph) << "\n\n";
}

void HelloNewPass::testAreTwoSubgraphIndependent2()
{
	std::vector<node*> O1layer;
	O1layer.push_back(findNodeById(85));

	std::vector<node*> O2layer;
	O2layer.push_back(findNodeById(90));
	O2layer.push_back(findNodeById(102));

	std::vector<node*> O3layer;
	O3layer.push_back(findNodeById(93));
	
	std::vector<node*> O4layer;
	O4layer.push_back(findNodeById(110));

	std::vector<node*> T1layer;
	T1layer.push_back(findNodeById(169));

	std::vector<node*> T2layer;
	T2layer.push_back(findNodeById(174));
	T2layer.push_back(findNodeById(186));

	std::vector<node*> T3layer;
	T3layer.push_back(findNodeById(177));
	
	std::vector<node*> T4layer;
	T4layer.push_back(findNodeById(194));

	graph Ograph;
	Ograph[0] = O1layer;
	Ograph[1] = O2layer;
	Ograph[2] = O3layer;
	Ograph[3] = O4layer;

	graph Tgraph;
	Tgraph[0] = T1layer;
	Tgraph[1] = T2layer;
	Tgraph[2] = T3layer;
	Tgraph[3] = T4layer;

	//Ӧ�÷���False
	errs() <<"IsGraphIndependent: "<< areTwoSubgraphIndependent(Ograph, Tgraph) << "\n\n";
}

bool HelloNewPass::areTwoSubgraphIndependent(graph& subgraph1,graph& subgraph2)
{
	std::unordered_map<node*, bool> node2flag;//���ڶԽڵ������
	//ʹ�� node2flag["""node*"""] = true; �Խڵ������
	//ʹ�� if( node2flag.find("""node*""")==node2flag.end() ) �ж��Ƿ��Ѿ�������ýڵ�
	//����ʹ�� if( node2flag["""node*"""] == true ) , ��Ϊ node2flag["""node*"""] �����Զ�����һ��key-value�Զ�
	//ʹ�� node2flag.clear() ���������ϣ��(unordered_map), �Ӷ�ʵ�ֶԽڵ��ǵĳ�ʼ��
	
	std::set<node*> predecessorsOfSubgraph1;
	std::set<node*> Subgraph2;
	node2flag.clear();
	//int count=0;
	for(long unsigned int l = 0;l<subgraph1.size();l++)
	{
		for(long unsigned int i = 0;i<subgraph1[l].size();i++)
		{
			//To do...
			// find all predecessors of one node first
			std::queue<node*> q;
			
			node* n = subgraph1[l][i];
			//n->predecessors//.....to do
			//n->predecessors => vector<node*>
			//n->predecessors �� vector<node*> ���ͣ�������������n��ǰ��
			//for(int p = 0;p<n->predecessors.size();p++) //����������� ��BFS��
			{
				//node* pn = n->predecessors[p];
				q.push(n);
				node2flag[n] = true; 
				while(!q.empty())
				{
					node* px=q.front();
					q.pop();
					predecessorsOfSubgraph1.insert(px);
					//count++;
					//px->predecessors �� vector<node*> ���ͣ�������������px��ǰ��
					for(long unsigned int pp = 0;pp<px->predecessors.size();pp++)
					{
						node* ppn = px->predecessors[pp];
						if(node2flag.find(ppn)==node2flag.end())
						{
							q.push(ppn);
							node2flag[ppn] = true;
							

						}
						
					}					
				}
			}
		}
	}
	//std::cout<<count;
	for(long unsigned int l = 0;l<subgraph2.size();l++)
	{
		for(long unsigned int i = 0;i<subgraph2[l].size();i++)
		{
			node* n = subgraph2[l][i];
			Subgraph2.insert(n);
		}
	}

	std::set<node*>::iterator it = predecessorsOfSubgraph1.begin();
	std::set<node*>::iterator it1 = Subgraph2.begin();
	while(it!= predecessorsOfSubgraph1.end() && it1 != Subgraph2.end())
	{
		if(*it<*it1){
			it++;
		}
		else if(*it>*it1){
			it1++;
		}
		else{
			return false;
		}
	}
	//���������е�����Ԫ�� 
	//for (it = predecessorsOfSubgraph1.begin();it!=predecessorsOfSubgraph1.end();it++)
	//{
	//	for(it1 = Subgraph2.begin(); it1 != Subgraph2.end(); it1++)
	//	{
	//		
	//		if (*it1 == *it)
	//		{
	//			return false;
	//		}	
	//	}
	//}

	
	
	std::set<node*> predecessorsOfSubgraph2;
	std::set<node*> Subgraph1;
	node2flag.clear();
	for(long unsigned int l = 0;l<subgraph2.size();l++)
	{
		for(long unsigned int i = 0;i<subgraph2[l].size();i++)
		{
			
			std::queue<node*> q;
			node* n = subgraph2[l][i];
			//for(int p = 0;p<n->predecessors.size();p++) //����������� ��BFS��
			{
				//node* pn = n->predecessors[p];
				q.push(n);
				node2flag[n] = true; 
				while(!q.empty())
				{
					node* px=q.front();
					q.pop();
					predecessorsOfSubgraph2.insert(px);
					//px->predecessors �� vector<node*> ���ͣ�������������px��ǰ��
					for(long unsigned int pp = 0;pp<px->predecessors.size();pp++)
					{
						node* ppn = px->predecessors[pp];
						if(node2flag.find(ppn)==node2flag.end())
						{
							q.push(ppn);
							node2flag[ppn] = true; 
						}
					}					
				}
			}
		}
	}
	for(long unsigned int l = 0;l<subgraph1.size();l++)
	{
		for(long unsigned int i = 0;i<subgraph1[l].size();i++)
		{
			node* n = subgraph1[l][i];
			Subgraph1.insert(n);
		}
	}

	std::set<node*>::iterator it2 = predecessorsOfSubgraph2.begin();
	std::set<node*>::iterator it3 = Subgraph1.begin();
	while(it2!= predecessorsOfSubgraph2.end() && it3 != Subgraph1.end())
	{
		if(*it2<*it3){
			it2++;
		}
		else if(*it2>*it3){
			it3++;
		}
		else{
			return false;
		}
	}
	//for (it2 = predecessorsOfSubgraph2.begin();it2!=predecessorsOfSubgraph2.end();it2++)
	//{
	//	for(it3 = Subgraph1.begin(); it3 != Subgraph1.end(); it3++)
	//	{
	//		if (*it2 == *it3)
	//		{
	//			return false;
	//		}	
	//	}
	//}
	

	
	/*for(subgraph1.begin();subgraph1.end();)
	{
		for(subgraph2.begin();subgraph2.end();)
		{
			if(subgraph1.predecessors==subgraph2)
			{
				return false;
			}
			subgraph2.predecessors=(subgraph2->predecessors).predecessor;
		}	
		subgraph1.predecessors=(subgraph1->predecessors).predecessor;
	}
	for(subgraph2.begin();subgraph2.end();)
	{
		for(subgraph1.begin();subgraph1.end();)
		{
			if(subgraph2.predecessors==subgraph1)
			{
				return false;
			}
			subgraph1.predecessors=(subgraph1->predecessors).predecessor;
		}	
		subgraph2.predecessors=(subgraph2->predecessors).predecessor;
	}*/
	
	return true;
}

bool HelloNewPass::areSubgraphsAllIndependent(std::vector<graph>& subgraphs)
{
	for (long unsigned int i = 0; i < subgraphs.size(); i++)
	{
		for (long unsigned int j = i + 1; j < subgraphs.size(); j++)
		{
			if (!areTwoSubgraphIndependent(subgraphs[i], subgraphs[j]))
			{
				return false;
			}
		}
	}
	return true;
}

bool HelloNewPass::areTwoNodeIndependent(node* node1,node* node2)
{
	std::string node1Id = std::to_string(node1->id);
	std::string node2Id = std::to_string(node2->id);
	std::string key1 = node1Id + "_" + node2Id;
	std::string key2 = node2Id + "_" + node1Id;
	if(node2nodeIndependent.find(key1) != node2nodeIndependent.end())
		return node2nodeIndependent[key1];


	std::unordered_map<node*, bool> node2flag;
	
	std::set<node*> predecessorsOfNode1;
	node2flag.clear();
	
	std::queue<node*> q;
	q.push(node1);
	while(!q.empty())
	{
		node* px=q.front();
		q.pop();
		predecessorsOfNode1.insert(px);
		for(long unsigned int pp = 0;pp<px->predecessors.size();pp++)
		{
			node* ppn = px->predecessors[pp];
			if(node2flag.find(ppn)==node2flag.end())
			{
				q.push(ppn);
				node2flag[ppn] = true;
			}
		}					
	}
	if(std::find(predecessorsOfNode1.begin(),predecessorsOfNode1.end(),node2) != predecessorsOfNode1.end())
	{
		node2nodeIndependent[key1] = false;
		node2nodeIndependent[key2] = false;
		return false;
	}


	std::set<node*> predecessorsOfNode2;
	node2flag.clear();
	
	q.push(node2);
	while(!q.empty())
	{
		node* px=q.front();
		q.pop();
		predecessorsOfNode2.insert(px);
		for(long unsigned int pp = 0;pp<px->predecessors.size();pp++)
		{
			node* ppn = px->predecessors[pp];
			if(node2flag.find(ppn)==node2flag.end())
			{
				q.push(ppn);
				node2flag[ppn] = true;
			}
		}					
	}
	if(std::find(predecessorsOfNode2.begin(),predecessorsOfNode2.end(),node1) != predecessorsOfNode2.end())
	{
		node2nodeIndependent[key1] = false;
		node2nodeIndependent[key2] = false;
		return false;
	}
	node2nodeIndependent[key1] = true;
	node2nodeIndependent[key2] = true;
	return true;
}

//�ж��Ƿ����е���Щ�ڵ��໥������������������true��������������false
bool HelloNewPass::areNodesAllIndependent(std::vector<node*>& nodes)
{
	for(long unsigned int i = 0;i<nodes.size();i++)
	{
		for(long unsigned int j = i+1;j<nodes.size();j++)
		{
			if(!areTwoNodeIndependent(nodes[i],nodes[j]))
			{
				return false;
			}
		}
	}
	return true;
}

bool HelloNewPass::areTwoNodeSame(node* node1, node* node2)
{
	if (node1->opcodeName == node2->opcodeName &&
		node1->predecessors.size() == node2->predecessors.size() &&
		node1->successors.size() == node2->successors.size())
	{
		return true;
	}
	return false;
}

void HelloNewPass::testAreTwoSubgraphSame1()
{
	node* O1a = new node(NULL,"1",0,"A");
	node* O1b1 = new node(NULL,"1",0,"B");
	node* O1b2 = new node(NULL,"2",0,"B");
	node* O1b3 = new node(NULL,"3",0,"B");
	node* O1c1 = new node(NULL,"1",0,"C");
	node* O1c2 = new node(NULL,"2",0,"C");
	
	node* O2d1 = new node(NULL,"1",0,"D");
	node* O2d2 = new node(NULL,"2",0,"D");
	
	node* O3e1 = new node(NULL,"1",0,"E");
	node* O3e2 = new node(NULL,"2",0,"E");
	
	O2d1->predecessors.push_back(O1b1);O1b1->successors.push_back(O2d1);
	O2d1->predecessors.push_back(O1b2);O1b2->successors.push_back(O2d1);
	O2d2->predecessors.push_back(O1b3);O1b3->successors.push_back(O2d2);
	O2d2->predecessors.push_back(O1c1);O1c1->successors.push_back(O2d2);

	O3e1->predecessors.push_back(O2d1);O2d1->successors.push_back(O3e1);
	O3e2->predecessors.push_back(O2d2);O2d2->successors.push_back(O3e2);
	O3e1->predecessors.push_back(O1a);O1a->successors.push_back(O3e1);
	


	node* T1a = new node(NULL,"1",0,"A");
	node* T1b1 = new node(NULL,"1",0,"B");
	node* T1b2 = new node(NULL,"2",0,"B");
	node* T1b3 = new node(NULL,"3",0,"B");
	node* T1c1 = new node(NULL,"1",0,"C");
	node* T1c2 = new node(NULL,"2",0,"C");
	
	node* T2d1 = new node(NULL,"1",0,"D");
	node* T2d2 = new node(NULL,"2",0,"D");
	
	node* T3e1 = new node(NULL,"1",0,"E");
	node* T3e2 = new node(NULL,"2",0,"E");

	T2d1->predecessors.push_back(T1b1);T1b1->successors.push_back(T2d1);
	T2d1->predecessors.push_back(T1b2);T1b2->successors.push_back(T2d1);
	T2d2->predecessors.push_back(T1b3);T1b3->successors.push_back(T2d2);
	T2d2->predecessors.push_back(T1c2);T1c2->successors.push_back(T2d2);

	T3e1->predecessors.push_back(T2d2);T2d2->successors.push_back(T3e1);
	T3e2->predecessors.push_back(T1a);T1a->successors.push_back(T3e2);
	T3e2->predecessors.push_back(T2d1);T2d1->successors.push_back(T3e2);

	std::vector<node*> O1layer;
	O1layer.push_back(O1a); O1a->depth = 10;
	O1layer.push_back(O1b1); O1b1->depth = 10;
	O1layer.push_back(O1b2); O1b2->depth = 10;
	O1layer.push_back(O1b3); O1b3->depth = 10;
	O1layer.push_back(O1c1); O1c1->depth = 10;
	O1layer.push_back(O1c2); O1c2->depth = 10;
	std::vector<node*> O2layer;
	O2layer.push_back(O2d1); O2d1->depth = 11;
	O2layer.push_back(O2d2); O2d2->depth = 11;
	std::vector<node*> O3layer;
	O3layer.push_back(O3e1); O3e1->depth = 12;
	O3layer.push_back(O3e2); O3e2->depth = 12;

	std::vector<node*> T1layer;
	T1layer.push_back(T1a); T1a->depth = 100;
	T1layer.push_back(T1b1); T1b1->depth = 100;
	T1layer.push_back(T1b2); T1b2->depth = 100;
	T1layer.push_back(T1b3); T1b3->depth = 100;
	T1layer.push_back(T1c1); T1c1->depth = 100;
	T1layer.push_back(T1c2); T1c2->depth = 100;
	std::vector<node*> T2layer;
	T2layer.push_back(T2d1); T2d1->depth = 101;
	T2layer.push_back(T2d2); T2d2->depth = 101;
	std::vector<node*> T3layer;
	T3layer.push_back(T3e1); T3e1->depth = 102;
	T3layer.push_back(T3e2); T3e2->depth = 102;

	graph Ograph;
	Ograph[0] = O1layer;
	Ograph[1] = O2layer;
	Ograph[2] = O3layer;

	graph Tgraph;
	Tgraph[0] = T1layer;
	Tgraph[1] = T2layer;
	Tgraph[2] = T3layer;


	errs() <<"IsGraphMatch: "<< areTwoSubgraphSame(Ograph, Tgraph) << "\n\n";

	for(long unsigned int l = 0;l<Ograph.size();l++)
	{
		for(long unsigned int i = 0;i<Ograph[l].size();i++)
		{
			errs() << Ograph[l][i]->opcodeName << "(" <<  Ograph[l][i]->valueName <<")   ";
		}
		errs()<<"\n";
	}
	errs()<<"\n";
	for(long unsigned int l = 0;l<Tgraph.size();l++)
	{
		for(long unsigned int i = 0;i<Tgraph[l].size();i++)
		{
			errs() << Tgraph[l][i]->opcodeName << "(" <<  Tgraph[l][i]->valueName <<")   ";
		}
		errs()<<"\n";
	}
	errs()<<"\n";
}

void HelloNewPass::testAreTwoSubgraphSame2()
{
	std::vector<node*> O1layer;
	O1layer.push_back(findNodeById(8));

	std::vector<node*> O2layer;
	O2layer.push_back(findNodeById(37));
	O2layer.push_back(findNodeById(26));

	std::vector<node*> O3layer;
	O3layer.push_back(findNodeById(49));
	O3layer.push_back(findNodeById(61));
	
	std::vector<node*> O4layer;
	O4layer.push_back(findNodeById(78));

	std::vector<node*> T1layer;
	T1layer.push_back(findNodeById(93));

	std::vector<node*> T2layer;
	T2layer.push_back(findNodeById(110));
	T2layer.push_back(findNodeById(121));

	std::vector<node*> T3layer;
	T3layer.push_back(findNodeById(133));
	T3layer.push_back(findNodeById(145));
	
	std::vector<node*> T4layer;
	T4layer.push_back(findNodeById(162));

	graph Ograph;
	Ograph[0] = O1layer;
	Ograph[1] = O2layer;
	Ograph[2] = O3layer;
	Ograph[3] = O4layer;

	graph Tgraph;
	Tgraph[0] = T1layer;
	Tgraph[1] = T2layer;
	Tgraph[2] = T3layer;
	Tgraph[3] = T4layer;

	errs() <<"IsGraphMatch: "<< areTwoSubgraphSame(Ograph, Tgraph) << "\n\n";

	for(long unsigned int l = 0;l<Ograph.size();l++)
	{
		for(long unsigned int i = 0;i<Ograph[l].size();i++)
		{
			errs() << Ograph[l][i]->opcodeName << "(" <<  Ograph[l][i]->valueName <<")   ";
		}
		errs()<<"\n";
	}
	errs()<<"\n";
	for(long unsigned int l = 0;l<Tgraph.size();l++)
	{
		for(long unsigned int i = 0;i<Tgraph[l].size();i++)
		{
			errs() << Tgraph[l][i]->opcodeName << "(" <<  Tgraph[l][i]->valueName <<")   ";
		}
		errs()<<"\n";
	}
	errs()<<"\n";
}


bool HelloNewPass::areTwoSubgraphSame(graph& subgraph1,graph& subgraph2)
{
	assert(!subgraph1.empty());
	if(subgraph1.size() != subgraph2.size())
		return false;
	//�ж�ÿ��Ľڵ�����Ƿ����
	for(long unsigned int i = 0;i<subgraph1.size();i++)
	{
		if(subgraph1[i].size() != subgraph2[i].size())
		{
			return false;
		}
	}
	
	//�ж�ÿ��Ľڵ������Ƿ��ܶ�Ӧ��
	for(long unsigned int l = 0;l<subgraph1.size();l++)
	{
		std::vector<bool> flag;
		for(long unsigned int i = 0;i<subgraph2[l].size();i++)
		{
			flag.push_back(false);
		}
		for(long unsigned int i = 0;i<subgraph1[l].size();i++)
		{
			node* ni = subgraph1[l][i];
			bool f = false;
			for(long unsigned int j = 0;j<subgraph2[l].size();j++)
			{
				if(flag[j])
					continue;
				node* nj = subgraph2[l][j];
				if(areTwoNodeSame(ni, nj))
				{
					flag[j] = true;
					f = true;
					break;
				}
			}
			if(!f)
			{
				return false;
			}
		}
	}
	
	return areTwoSubgraphLayerSame(subgraph1, subgraph2, 0);
}


bool HelloNewPass::areTwoSubgraphLayerSame(graph& subgraph1,graph& subgraph2, long unsigned int layerId)
{
	if(layerId >= subgraph1.size())
	{
		return true;
	}
	std::vector<node*> oriOrder;//��¼ͼһ��ǰ��Ľڵ�,ͼ����ǰ����ͼһ��ǰ��ƥ��
	std::vector<std::vector<node*>> SearchOrders; //���е�ͼ����ǰ��Ŀ��ܽ��
	std::vector<std::vector<bool>> SearchFlags;
	long unsigned int curSearchOrderId = 0;

	std::vector<node*> searchOrder;
	std::vector<bool> flag;

	SearchOrders.push_back(searchOrder);
	for(long unsigned int i = 0;i<subgraph2[layerId].size();i++)
	{
		flag.push_back(false);
	}
	SearchFlags.push_back(flag);

	while(SearchOrders[curSearchOrderId].size() < subgraph1[layerId].size())
	{
	
		for(long unsigned int i = SearchOrders[curSearchOrderId].size();i<subgraph1[layerId].size();i++)
		{
			node* ni = subgraph1[layerId][i];
			std::vector<int> findId;
			for(long unsigned int j = 0;j<subgraph2[layerId].size();j++)
			{
				if(SearchFlags[curSearchOrderId][j])
					continue;
				node* nj = subgraph2[layerId][j];
				if(areTwoNodeSame(ni, nj))
				{
					findId.push_back(j);
				}
			}

			
			for(long unsigned int j = 1;j < findId.size();j++)
			{
				SearchOrders.push_back(SearchOrders[curSearchOrderId]);
				SearchFlags.push_back(SearchFlags[curSearchOrderId]);

				SearchOrders[SearchOrders.size() - 1].push_back(subgraph2[layerId][findId[j]]);
				SearchFlags[SearchFlags.size() - 1][findId[j]] = true;
			}
			SearchOrders[curSearchOrderId].push_back(subgraph2[layerId][findId[0]]);
			SearchFlags[curSearchOrderId][findId[0]] = true;

		}
		curSearchOrderId++;
		if(curSearchOrderId == SearchOrders.size())
		{
			break;
		}
	}

	/*for(int i = 0;i<SearchOrders.size(); i++)
	{
		for(int j = 0;j<SearchOrders[i].size();j++)
		{
			errs() << SearchOrders[i][j]->opcodeName << "(" << SearchOrders[i][j]->valueName <<")   ";

		}
		errs()<<"\n";
	}*/

	//bool matched = false;
	for(long unsigned int i = 0;i<SearchOrders.size(); i++)
	{
		subgraph2[layerId] = SearchOrders[i];
		bool allNodesOffLayerMatched = true;
		for(long unsigned int j = 0;j<subgraph2[layerId].size();j++)
		{
			if(!areTwoNodeMatchInSubgraph(subgraph1,subgraph2,layerId,j))
			{
				allNodesOffLayerMatched = false;
				break;
			}
		}

		if(allNodesOffLayerMatched)
		{
			if(areTwoSubgraphLayerSame(subgraph1,subgraph2,layerId+1))
			{
				return true;
			}
		}
		//return false;
	}
	return false;
}


bool HelloNewPass::areTwoNodeMatchInSubgraph(graph& subgraph1,graph& subgraph2, long unsigned int layerId, int nodeId)
{
	node* n1 = subgraph1[layerId][nodeId];
	node* n2 = subgraph2[layerId][nodeId];
	if(areTwoNodeSame(n1, n2))
	{
		if(layerId == 0)
		{
			return true;
		}

		//�ж��ϲ㸸�ڵ��λ���Ƿ���ȷ������ֻҪλ����ȷ�����ڵ�����;�һ����ȷ����Ϊ�ڹ���ÿ���˳���ʱ�򣬾��ǰ�����ͬ���͵ļ���ڵ㹹���
		std::set<std::pair<int,int>> predecessors1;
		for(long unsigned int i =0; i < n1->predecessors.size(); i++)
		{
			node* n1p = n1->predecessors[i];
			long unsigned int delteDepth = n1->depth - n1p->depth;
			if(delteDepth <= layerId)
			{
				for(long unsigned int j = 0;j<subgraph1[layerId-delteDepth].size();j++)
				{
					if(subgraph1[layerId-delteDepth][j] == n1p)
					{
						predecessors1.insert(std::pair<int,int>(j,layerId - delteDepth));
						break;
					}
				}
			}
			
		}
		std::set<std::pair<int,int>> predecessors2;
		for(long unsigned int i =0; i < n2->predecessors.size(); i++)
		{
			node* n2p = n2->predecessors[i];
			long unsigned int delteDepth = n2->depth - n2p->depth;
			if(delteDepth <= layerId)
			{
				for(long unsigned int j = 0;j<subgraph2[layerId-delteDepth].size();j++)
				{
					if(subgraph2[layerId-delteDepth][j] == n2p)
					{
						predecessors2.insert(std::pair<int,int>(j,layerId - delteDepth));
						break;
					}
				}
			}
		}

		if (predecessors1.size() != predecessors2.size()){
			return false;
		}
		std::set<std::pair<int,int>>::iterator it;
		std::set<std::pair<int,int>>::iterator it1;
		//���������е�����Ԫ�� 
		for (it = predecessors1.begin(), it1 = predecessors2.begin(); it != predecessors1.end(); it++, it1++){
			if (it1->first != it->first || it1->second != it->second){
				return false;
			}
		}
		return true;
	}
	return false;
}

std::vector<std::vector<long unsigned int>> HelloNewPass::getCombination(int n, int cn)
{
	std::vector<std::vector<long unsigned int>> ret;
	std::vector<long unsigned int> vec;
    for(int i = 1;i<=cn;i++){
        vec.push_back(i);
    }

    while(true)
	{
        ret.push_back(vec);
		
		int k = cn - 1;
		for(;k>=0;k--){
			if(vec[k] < n + k - vec.size() + 1) break;
		}
		if(k<0) 
			break;
		vec[k]++;
		for(long unsigned int i=k+1;i<vec.size();i++)
		{
			vec[i] = vec[i-1] + 1;
		}
    }
	return ret;
}