export default function Icon({className, id, onClick, name}) {
  return (
    <i 
      className={className !== undefined ? "icon " + className : "icon"} 
      id={id} 
      onClick={onClick}
      >
      {name}
      </i>
  )
}