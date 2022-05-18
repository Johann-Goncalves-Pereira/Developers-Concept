function withOpacityValue(variable) {
  return ({ opacityValue }) => {
    if (opacityValue === undefined) {
      return `hsl(var(${variable}))`;
    }
    return `hsla(var(${variable}), ${opacityValue})`;
  };
}

module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx,elm}"],
  theme: {
    colors: {
      //& Surface
      "primary-0": withOpacityValue("--clr-primary-0-alpha"),
      "primary-1": withOpacityValue("--clr-primary-1-alpha"),
      "primary-2": withOpacityValue("--clr-primary-2-alpha"),
      // & Secondary
      "secondary-0": withOpacityValue("--clr-secondary-0-alpha"),
      "secondary-1": withOpacityValue("--clr-secondary-1-alpha"),
      "secondary-2": withOpacityValue("--clr-secondary-2-alpha"),
      "secondary-3": withOpacityValue("--clr-secondary-3-alpha"),
      // & Accent
      "accent-0": withOpacityValue("--clr-accent-0-alpha"),
      "accent-1": withOpacityValue("--clr-accent-1-alpha"),
      "accent-2": withOpacityValue("--clr-accent-2-alpha"),
      "accent-3": withOpacityValue("--clr-accent-3-alpha"),
      // & Gradients
      "gradients-0": withOpacityValue("--clr-gradients-0-alpha"),
      "gradients-1": withOpacityValue("--clr-gradients-1-alpha"),
      // & Lines
      "lines-0": withOpacityValue("--clr-lines-0-alpha"),
    },
    fontWeight: {
      "medium-less": 450,
    },
    // extend: {},
  },
  plugins: [],
  corePlugins: {
    preflight: false,
  },
};
