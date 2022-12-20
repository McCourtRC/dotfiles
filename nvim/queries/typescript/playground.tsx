type Person = {
:qa

  name: string;
};
const list_of_numbers = [2, 3];

const list_of_objects = [
  { name: "bob" },
  { "name-someething": "george" },
  { name: "steve" },
];
const list_of_lists = [[1], [2], [30, 40, 50]];

const object = {
  foo: "foo",
  bar: "bar",
  baz: "baz",
};

const nested_object = {
  outer: {
    inner: "value",
    fn: () => { }
  },
};

nested_object.outer.inner;

function something(a: number, another: string) {
  // console.log
}

function Component(b: number) {
  return (
    <div>
      <h1>Title</h1>
      <p>paragraph with some words</p>
    </div>
  )
}
