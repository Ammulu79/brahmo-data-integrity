import { useEffect, useState } from "react";
import "./App.css";

function App() {
  const [nodes, setNodes] = useState([]);
  const [audit, setAudit] = useState([]);

  useEffect(() => {
    fetch("http://localhost:5000/nodes")
      .then((res) => res.json())
      .then((data) => setNodes(data));

    fetch("http://localhost:5000/audit")
      .then((res) => res.json())
      .then((data) => setAudit(data));
  }, []);

  return (
    <div className="container">
      <h1 className="title">Brahmo Data Integrity Dashboard</h1>
<div className="stats-grid">
  <div className="stat-box">
    <h2>{nodes.length}</h2>
    <p>Total Nodes</p>
  </div>

  <div className="stat-box">
    <h2>
      {nodes.filter((n) => n.status === "ACTIVE").length}
    </h2>
    <p>Active Nodes</p>
  </div>

  <div className="stat-box">
    <h2>
      {nodes.filter((n) => n.status === "SUPERSEDED").length}
    </h2>
    <p>Superseded</p>
  </div>

  <div className="stat-box">
    <h2>{audit.length}</h2>
    <p>Audit Events</p>
  </div>
</div>
      <h2 className="section-title">Knowledge Nodes</h2>

      <div className="card-grid">
        {nodes.map((node) => (
          <div key={node.id} className="card">
            <h3>{node.title}</h3>

            <p>
              <strong>ID:</strong> {node.id}
            </p>

            <p>
              <strong>Department:</strong> {node.department}
            </p>

            <p>{node.content}</p>

            <div className="status">{node.status}</div>
          </div>
        ))}
      </div>

      <h2 className="section-title">Audit Timeline</h2>

      <div className="card-grid">
        {audit.map((item) => (
          <div key={item.id} className="card audit-card">
            <p>
              <strong>Action:</strong> {item.action}
            </p>

            <p>
              <strong>Node:</strong> {item.node_id}
            </p>

            <p>
              <strong>Actor:</strong> {item.actor_id}
            </p>

            <p>
              <strong>Old Value:</strong> {item.old_value}
            </p>

            <p>
              <strong>New Value:</strong> {item.new_value}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;