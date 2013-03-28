class SortingMachineConfig {

	private boolean animated;
	private int noteHeight;
	private float stepWidth;
	private WindowConfig window;
	private SortJobConfig[] sortJobConfigs;
	private Map<String, DataConfig> dataById;

	public SortingMachineConfig(Map<String, Object> in) {
		this.animated = (Boolean)in.get("animated");
		this.window = new WindowConfig((Map<String, Object>)in.get("window"));
		List<Object> list = (List<Object>)in.get("jobs");
		sortJobConfigs = new SortJobConfig[list.size()];
		for(int i = 0; i < list.size(); i++) {
			Map<String, Object> m = (Map<String, Object>)list.get(i);
			sortJobConfigs[i] = new SortJobConfig(m);
		}
		dataById = new HashMap<String, DataConfig>();
		Map<String, Object> datamap = (Map<String, Object>)in.get("data");
		for(String id : datamap.keySet()) {
			dataById.put(id, new DataConfig((Map<String, Object>)datamap.get(id)));
		}
		noteHeight = (Integer)in.get("noteheight");
		stepWidth = ((Double)in.get("stepwidth")).floatValue();
	}

	public boolean isAnimated() {
		return this.animated;
	}

	public int getNoteHeight() {
		return this.noteHeight;
	}

	public float getStepWidth() {
		return this.stepWidth;
	}

	public WindowConfig getWindow() {
		return this.window;
	}

	public SortJobConfig[] getSortJobConfigs() {
		return this.sortJobConfigs;
	}

	public DataConfig getDataConfig(String id) {
		return dataById.get(id);
	}

	public String toString() {
		return Objects.toStringHelper(this)
			.add("animated", animated)
			.toString();
	}

}

class SortJobConfig {

	private String label;
	private String sort;
	private String dataRef;

	SortJobConfig(Map<String, Object> in) {
		this.label = (String)in.get("label");
		this.sort = (String)in.get("sort");
		this.dataRef = (String)in.get("data");
	}

	public String getLabel() {
		return this.label;
	}

	public String getSort() {
		return sort;
	}

	public String getDataRef() {
		return dataRef;
	}
}

class DataConfig {

	private String label;
	private int[] values;
	private RandomDataConfig randomData;
	private String[] steps;

	DataConfig(Map<String, Object> in) {
		this.label = (String)in.get("label");
		if(in.containsKey("values")) {
			this.values = asIntArray(in, "values");
		}
		else if(in.containsKey("random")) {
			randomData = new RandomDataConfig((Map<String, Object>)in.get("random"));
		}
		else {
			throw new RuntimeException("no data specified in data set");
		}
		if(in.containsKey("steps")) {
			this.steps = asStringArray(in, "steps");
		}
		else {
			this.steps = new String[0];
		}
	}

	public String getLabel() {
		return this.label;
	}

	public boolean valuesInlined() {
		return this.values != null;
	}

	public int[] getValues() {
		return this.values;
	}

	public RandomDataConfig getRandomDataConfig() {
		return this.randomData;
	}

	public String[] getSteps() {
		return this.steps;
	}
}

class RandomDataConfig {

	private int size;
	private int[] uniqueValues;

	RandomDataConfig(Map<String, Object> in) {
		this.size = (Integer)in.get("size");
		this.uniqueValues = asIntArray(in, "values");
	}

	public int getSize() {
		return this.size;
	}

	public int[] getUniqueValues() {
		return copy(this.uniqueValues);
	}
}

class WindowConfig {

	private int width;
	private int height;
	private float leftMargin;
	private float rightMargin;
	private float topMargin;
	private float bottomMargin;

	public WindowConfig(Map<String, Object> in) {
		this.width = (Integer)in.get("width");
		this.height = (Integer)in.get("height");
		int[] margins = asIntArray(in, "margins");
		setMargins(asIntArray(in, "margins"));
	}

	public int getWidth() { return this.width; } 
	public void setWidth(int width) { this.width = width; }
	public int getHeight() { return this.height; }
	public void setHeight(int height) { this.height = height; }

	public float getLeftMargin() {
		return this.leftMargin;
	}

	public float getRightMargin() {
		return this.rightMargin;
	}

	public float getTopMargin() {
		return this.topMargin;
	}

	public float getBottomMargin() {
		return this.bottomMargin;
	}

	public void setMargins(int[] margins) {
		if(margins.length != 4) {
			throw new RuntimeException("margin should be size = 4");
		}
		this.topMargin = (float)margins[0];
		this.rightMargin = (float)margins[1];
		this.bottomMargin = (float)margins[2];
		this.leftMargin = (float)margins[3];
	}
}

