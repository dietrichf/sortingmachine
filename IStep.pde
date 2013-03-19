interface IStep {

	// the low index of the compare
	public int lo();

	// the hi index of the compare
	public int hi();

	// swap hi and lo positions?
	public boolean swap();

	// return any other miscellaneous control points specific to the given sorting algorithm
	// for example quicksort maintains a pivot point and shellsort maintains staggered indexes
	// of incremental sorts
	public int[] controlPoints();

	public boolean isControlPoint(int i);
}
