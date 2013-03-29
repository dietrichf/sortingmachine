interface Sorter {
	/**
	 * plan the sort, returning the steps required
	 */
	List<Instruction> plan(int[] items);
}
