export default function Form({children, error}) {
  return (
    <form>
      {error !== "" ? <p>{error}</p> : ""}
      {children}
    </form>
  )
}