ArrayList<Node> aStar(Node start, Node goal) {
  PriorityQueue<Node> open = new PriorityQueue<Node>();
  HashSet<Node> closed = new HashSet<Node>();

  start.g = 0;
  start.h = start.position.dist(goal.position);
  start.f = start.h;
  open.add(start);

  while (!open.isEmpty()) {
    Node current = open.poll();
    if (current == goal) {
      ArrayList<Node> path = new ArrayList<>();
      path.add(current);
      while (path.get(0) != start) {
        path.add(0, path.get(0).parent);
      }

      return path;
    }

    closed.add(current);
    for (Node neighbor : current.neighbors) {
      if (closed.contains(neighbor)) continue;

      float tentativeG = current.g + current.position.dist(neighbor.position);
      if (tentativeG < neighbor.g) {
        neighbor.parent = current;
        neighbor.g = tentativeG;
        neighbor.h = neighbor.position.dist(goal.position);
        neighbor.f = neighbor.g + neighbor.h;

        if (!open.contains(neighbor)) {
          open.add(neighbor);
        } else {
          open.remove(neighbor);
          open.add(neighbor);
        }
      }
    }
  }

  return null;
}

class NodeGraph {
  ArrayList<Node> nodes = new ArrayList<Node>();
  int level;
  Node santaNode = null;

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

    if (nodes.size() > 0) {
      float minDist = 99999;
      int minNodeIndex = 0;
      float tempDist;
      for (int i = 0; i < nodes.size(); i++) {
        nodes.get(i).display();
        text(i, nodes.get(i).position.x, nodes.get(i).position.y);

        tempDist = nodes.get(i).position.dist(santa.position);
        if (tempDist < minDist) {
          minDist = tempDist;
          minNodeIndex = i;
        }
      }
      santaNode = nodes.get(minNodeIndex);
    }
  }
}


class Node implements Comparable<Node> {
  PVector position;
  ArrayList<Node> neighbors = new ArrayList<Node>();
  ArrayList<Edge> edges = new ArrayList<Edge>();

  float f = Float.MAX_VALUE;
  float g = Float.MAX_VALUE;
  float h = 0;
  Node parent = null;


  Node(float x, float y) {
    position = new PVector(x, y);
  }

  void newEdge(Node neighbor) {
    edges.add(new Edge(this, neighbor));
    neighbors.add(neighbor);
  }

  void display() {
    fill(255, 0, 0, 64);
    circle(position.x, position.y, 50);

    for (int i = 0; i < edges.size(); i++) {
      edges.get(i).display();
    }
  }

  @Override
    public int compareTo(Node other) {
    return Float.compare(this.f, other.f);
  }

  @Override
    public boolean equals(Object obj) {
    if (obj == this) return true;
    if (!(obj instanceof Node)) return false;
    Node other = (Node)obj;
    return this.position.equals(other.position);
  }

  @Override
    public int hashCode() {
    return position.hashCode();
  }

  void reset() {
    f = Float.MAX_VALUE;
    g = Float.MAX_VALUE;
    h = 0;
    parent = null;
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
