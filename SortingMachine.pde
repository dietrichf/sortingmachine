class SortingMachine {
	
	private SortingMachineConfig config;

	private Map<String, DataSet> dataById = Maps.newHashMap();

	private List<SortJob> sortJobs = Lists.newArrayList();

	SortingMachine(SortingMachineConfig config) {
		this.config = config;
	}

	SortingMachine(String file) {
		try {
			ObjectMapper om = new ObjectMapper();
			Map<String, Object> config = om.readValue(
				new File("/Users/d/git/sortvis/config.json"),
				Map.class);
			System.out.println("config ->\n" + config);
			this.config = new SortingMachineConfig(config);
		}
		catch(Exception e) {
			e.printStackTrace(System.err);
			throw new RuntimeException(e);
		}
		for(SortJobConfig c : config.getSortJobConfigs()) {
			SortJob job = new SortJob(this, c);
			job.plan();
			System.out.println("adding job --> \n" + job + "\n");
			sortJobs.add(job);
		}
	}

	void setup() {
		size(
			this.config.getWindow().getWidth(),
			this.config.getWindow().getHeight());
		smooth();
	}

	Drawable getRenderer() {
		if(this.config.isAnimated()) {
			return new AnimatedRenderer(this);
		}
		return new Renderer(this);
	}

	DataSet getData(String id) {
		if(dataById.containsKey(id)) {
			return dataById.get(id);
		}
		DataConfig dc = config.getDataConfig(id);
		return new DataSet(dc);
	}

	List<SortJob> getSortJobs() {
		return this.sortJobs;
	}

	int getNoteHeight() {
		return config.getNoteHeight();
	}

	float getStepWidth() {
		return config.getStepWidth();
	}

	WindowConfig getWindow() {
		return config.getWindow();
	}
}

class SortJob {

	private String label;
	private Sorter sorter;
	private DataSet data;
	private List<Instruction> instructions;

	SortJob(SortingMachine m, SortJobConfig c) {
		this.label = c.getLabel();
		if(c.getSort().equals("quicksort")) {
			this.sorter = new QuickSorter();
		}
		else if(c.getSort().equals("bubblesort")) {
			this.sorter = new BubbleSorter();
		}
		else {
			throw new RuntimeException("sorter " + c.getSort() + " not found");
		}
		this.data = m.getData(c.getDataRef());
	}

	public String getLabel() {
		return this.label;
	}

	public void plan() {
		instructions = Lists.newLinkedList();
		instructions = sorter.plan(data.getValues());
	}

	public List<Instruction> getInstructions() {
		return instructions;
	}

	public DataSet getData() {
		return this.data;
	}

	public String toString() {
		return Objects.toStringHelper(this)
			.add("label", label)
			.add("sorter", sorter)
			.add("data", data)
			.toString();
	}
}

class DataSet {

	String label;
	int[] values;

	public DataSet(DataConfig config) {
		this.label = config.getLabel();
		if(config.valuesInlined()) {
			this.values = copy(config.getValues());
		}
		else {
			RandomDataConfig r = config.getRandomDataConfig();
			int[] pool = r.getUniqueValues();
			this.values = new int[r.getSize()];
			Random rand = new Random();
			for(int i = 0; i < values.length; i++) {
				this.values[i] = pool[Math.abs(rand.nextInt())%pool.length];
			}
		}

		String[] steps = config.getSteps();
		if(steps != null && steps.length > 0) {
			List<Integer> list = Lists.newArrayListWithCapacity(values.length);
			for(int i : values) {
				list.add(i);
			}
			for(String step : config.getSteps()) {
				if(step.equals("shuffle")) {
					Collections.shuffle(list);
				}
				else if(step.equals("reverse")) {
					Collections.reverse(list);
				}
				else if(step.equals("sort")) {
					Collections.sort(list);
				}
			}
			for(int i = 0; i < list.size(); i++) {
				values[i] = list.get(i);
			}
		}
	}

	public String getLabel() {
		return label;
	}

	public int[] getValues() {
		return copy(values);
	}

	public String toString() {
		return Objects.toStringHelper(this)
			.add("label", this.label)
			.add("values", join(this.values, ", "))
			.toString();
	}
}

