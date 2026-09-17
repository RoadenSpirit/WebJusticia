/** @type {import('tailwindcss').Config} */
export default {
	content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
	theme: {
		extend: {
			colors: {
				ministerial: {
					600: '#255388',
					700: '#183c66',
					800: '#0f2744',
					900: '#0c2340',
					950: '#061322',
				},
				heraldic: {
					gold: '#b8860b',
					'gold-light': '#fef3c7',
					'gold-border': '#fde68a',
				},
				justice: {
					50: '#f0f9ff',
					100: '#e0f2fe',
					200: '#bae6fd',
					500: '#0284c7',
					600: '#0369a1',
					700: '#075985',
					800: '#0c4a6e',
					900: '#082f49',
				}
			},
			fontFamily: {
				sans: ['Inter', 'Segoe UI', 'system-ui', '-apple-system', 'sans-serif'],
				mono: ['ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'monospace'],
			}
		},
	},
	plugins: [],
};
