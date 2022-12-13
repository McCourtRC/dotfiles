type Person = {
  name: string;
};
const list_of_numbers = [100, 2, 3];

const list_of_objects = [
  { name: "bob" },
  { name: "george" },
  { name: "steve" },
];
const list_of_lists = [[1], [2], [3]];

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

function something_b(b: number) { }
