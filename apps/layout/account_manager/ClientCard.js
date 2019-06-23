import { Link } from 'react-router-dom'

import Icon from "../components/Icon"
import Button from "../components/Button"

export default function ClientCard({className, id, logo, clientName, clientId, clientDesc}) {
  return (
    <div 
      className={className !== undefined ? "client-card " + className : "client-card"} 
      id={id}
      >
      {logo !== undefined ? (
        <img src={logo} className="client-card-logo" />
      ) : (
        <Icon className="client-card-logo" name="cloud" />
      )}
      <div className="client-card-spec">
        <Link to={"/apps/" + clientId} className="client-card-link">
          <span>
            {clientName}
          </span>
        </Link>
        <p>{clientDesc}</p>
      </div>
    </div>
  )
}