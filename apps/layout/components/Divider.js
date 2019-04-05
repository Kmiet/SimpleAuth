export default function Divider({className, id, text}) {
  return (
    <div 
      className={className ? className + " divider" : "divider"} 
      id={id}
      >
      {text}
      </div>
  )
}