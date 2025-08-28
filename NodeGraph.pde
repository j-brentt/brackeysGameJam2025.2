class NodeGraph {
  ArrayList<Node> nodes = new ArrayList<Node>();
  int level;

  NodeGraph(int level) {
    this.level = level;
  }

  void newNode(float x, float y) {
    nodes.add(new Node(x, y));
  }
  
  void newEdge(Node from, Node to) {
    from.newEdge(to);
    to.newEdge(from);
  }

  void display() {
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).display();
    }
  }
}


class Node {
  PVector position;
  ArrayList<Node> neighbors;
  ArrayList<Edge> edges = new ArrayList<Edge>();

  Node(float x, float y) {
    position = new PVector(x, y);
  }

  void newEdge(Node neighbor) {
    edges.add(new Edge(this, neighbor));
  }

  void display() {
    fill(255, 0, 0, 64);
    circle(position.x, position.y, 50);

    for (int i = 0; i < edges.size(); i++) {
      edges.get(i).display();
    }
  }
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

  void display() {
    fill(0);
    line(from.position.x, from.position.y, to.position.x, to.position.y);
  }
}
