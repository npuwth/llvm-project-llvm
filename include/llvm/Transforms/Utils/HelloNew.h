#ifndef LLVM_TRANSFORMS_HELLONEW_HELLONEW_H
#define LLVM_TRANSFORMS_HELLONEW_HELLONEW_H

#include "llvm/IR/PassManager.h"
#include <vector>
#include <unordered_map>
#include <iostream>
#include <fstream>
#include <set>
#include <algorithm>
#include <queue>
#include <map>

namespace llvm {

class HelloNewPass : public PassInfoMixin<HelloNewPass> {
	public:
 
	std::list<Instruction *>::iterator itor_former; //定义迭代器
	int num_function = 0;                           //用来记录多少个函数

	int num;

	class node{
	public:
		static int totalId;
		int id = 0;
		Value* value;
		std::string valueName;
		int opcode;
		std::string opcodeName;
		bool isArray = false;

		//for getelementptr and AryEleStore node
		std::string arrayName;
		std::string indexName;
		node* indexNode = NULL;

		std::vector<node*> predecessors;//前驱节点
		std::vector<node*> successors;  //后继节点

		node(Value* value, std::string valueName, int opcode, std::string opcodeName){
			this->value = value;
			this->valueName = valueName;
			this->opcode = opcode;
			this->opcodeName = opcodeName;
			
		}

		node(Value* value, std::string valueName){
			this->value = value;
			this->valueName = valueName;
			this->opcode = -1;
			this->opcodeName = "";
		}


		//用于计算同构无依赖子图
		int inCount;
		int depth;
	};

	std::map<Value*, node*> value2node;
	class edge{
	public:
		node* s;
		node* e;

		edge(node* s, node* e){
			this->s = s;
			this->e = e;
		}
	};
	std::vector<edge*> edges;//存储所有边
	std::vector<node*> nodes;//存储所有节点
	node* findNodeById(int id);

	std::map<Value*, std::string> value2name;
	std::string getValueName(Value *v);
	
	
	node* getNode(Value *v, Instruction* inst);
	
	void linkNode(node* s, node* e);
	edge* getEdge(node* s, node* e);

	void calculateEdge();

	void releaseNode();
	void releaseEdge();

	void simplify();

	void printBasicBlockNodesGraph(std::string fileName);


	void outputBasicBlockNodesGraph(std::string fileName, bool isSimple);

	//用于计算同构无依赖子图
	public:
        void releaseSubgraph();

		void calculateSubgraph();

		typedef std::map<long unsigned int,std::vector<node*>> graph;

		graph layers;
        void topologicalSort();
        
		//std::vector<node*> subgraph;
		
		bool areTwoNodeSame(node* node1, node* node2);

		void testAreTwoSubgraphSame1();
		void testAreTwoSubgraphSame2();
		bool areTwoSubgraphSame(graph& subgraph1,graph& subgraph2);


		void testAreTwoSubgraphIndependent1();
		void testAreTwoSubgraphIndependent2();
		bool areTwoSubgraphIndependent(graph& subgraph1,graph& subgraph2);
		bool areSubgraphsAllIndependent(std::vector<graph>& subgraphs);

		//key为 node1的id _ node2的id
		std::unordered_map<std::string, bool> node2nodeIndependent;
		bool areTwoNodeIndependent(node* node1,node* node2);
		bool areNodesAllIndependent(std::vector<node*>& nodes);

		bool isCalculateNode(node* node);
		std::vector<node*> getCommonParentNodes(std::vector<node*>& nodes);

		void findSameSubgraph();

		bool areTwoSubgraphLayerSame(graph& subgraph1,graph& subgraph2, long unsigned int layerId);

		bool areTwoNodeMatchInSubgraph(graph& subgraph1,graph& subgraph2, long unsigned int layerId, int nodeId);

		std::vector<std::vector<long unsigned int>> getCombination(int n, int cn);

		class Subgraph
		{
			public:
				graph _graph;
				std::set<node*> nodesCanExtend;
				int minDepth; //记录当前子图中节点具有的最小深度
				int maxDepth; //记录当前子图中节点具有的最大深度
		};

		class SameSubgraph
		{
		public:
			int nodeCountForSubgraph;
			std::vector<Subgraph> subgraphs;
			std::unordered_map<node*, bool> mask;
		};

		//全部的子图方案，key为操作码，value为以该操作码为核心的所有子图方案
		std::map<std::string, std::vector<SameSubgraph>> allSameSubgraphs;

		void extendSameSubgraph(SameSubgraph& sameSubgraph);
		bool extendSameSubgraphOnce(SameSubgraph& sameSubgraph);
		bool extendSameSubgraphOnceOneNode(SameSubgraph& sameSubgraph, std::vector<node*>& nodesExtendForEachSubgraph);

	public:
	PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

bool cmpNode(HelloNewPass::node* a,HelloNewPass::node* b);



} // namespace llvm

#endif // LLVM_TRANSFORMS_HELLONEW_HELLONEW_H
