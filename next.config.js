/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  images: {
    domains: ['ipfs.infura.io'],
    loader: 'imgix',
    path: '',
  },
  env: {
    projectId: process.env.REACT_APP_ALCHEMY_PROJECT_ID,
  },
}

