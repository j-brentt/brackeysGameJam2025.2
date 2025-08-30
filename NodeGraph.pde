class NodeGraph {
  ArrayList<Node> Nodes;
  int level;
  
  NodeGraph(int level) { 
    this.level = level;
  }
}


class Node {
  PVector position;
  ArrayList<Node> neighbors;
  ArrayList<Edge> edges;
  
  
}

class Edge {
  Node from;
  Node to;
  float distance;
  
  Edge(Node from, Node to) {
    this.from = from;
    this.to = to;
    distance = from.position.dist(to.position);
  }
}
