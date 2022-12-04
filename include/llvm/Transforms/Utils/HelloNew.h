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
 
	std::list<Instruction *>::iterator itor_former; //���������
	int num_function = 0;                           //������¼���ٸ�����

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

		std::vector<node*> predecessors;
		std::vector<node*> successors;

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


		//���ڼ���ͬ����������ͼ
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
	std::vector<edge*> edges;
	std::vector<node*> nodes;
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

	//���ڼ���ͬ����������ͼ
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

		//keyΪ node1��id _ node2��id
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
				int minDepth; //��¼��ǰ��ͼ�нڵ���е���С���
				int maxDepth; //��¼��ǰ��ͼ�нڵ���е�������
		};

		class SameSubgraph
		{
		public:
			int nodeCountForSubgraph;
			std::vector<Subgraph> subgraphs;
			std::unordered_map<node*, bool> mask;
		};

		//ȫ������ͼ������keyΪ�����룬 valueΪ�Ըò�����Ϊ���ĵ�������ͼ����
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
