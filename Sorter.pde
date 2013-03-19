interface Sorter {
	/**
	 * plan the sort, returning the steps required
	 */
	List<Step> plan(int[] items);
}
